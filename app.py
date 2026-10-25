"""Ask questions about the homeschool co-op database in plain English.

Flow: question -> Claude writes SQL -> run it on SQLite -> Claude turns the rows
into a plain-English answer.

Usage:
    python app.py                       # few-shot prompting (default)
    python app.py --strategy zero-shot  # schema only, no example
"""
import argparse
import json
import os
import re
import sqlite3

import anthropic

HERE = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(HERE, "homeschool.db")
SCHEMA_PATH = os.path.join(HERE, "schema.sql")
SECRETS_PATH = os.path.join(HERE, "secrets.json")

MODEL = "claude-opus-5-5"
EFFORT = "low"  # raise to "medium" or "high" if the SQL quality isn't good enough
MAX_RESULT_ROWS = 200  # cap on rows sent back to Claude for the answer

# One worked example from this same database, used by the few-shot strategy
FEW_SHOT_EXAMPLE = """Example question: Which students are taking Biology, and what grades do they have?
Example SQL:
SELECT s.full_name, cs.grade
FROM student s
JOIN course_student cs ON cs.student_id = s.student_id
JOIN course c ON c.course_id = cs.course_id
WHERE c.subject = 'Biology'
ORDER BY s.full_name;"""


def load_client():
    with open(SECRETS_PATH, encoding="utf-8") as f:
        key = json.load(f).get("anthropic_api_key")
    if not key:
        raise SystemExit('Add "anthropic_api_key" to secrets.json first.')
    return anthropic.Anthropic(api_key=key)


def ask_claude(client, system, prompt):
    response = client.beta.messages.create(
        model=MODEL,
        max_tokens=16000,
        system=system,
        messages=[{"role": "user", "content": prompt}],
        output_config={"effort": EFFORT},
        # On a safety refusal, the API retries on a fallback model automatically
        betas=["server-side-fallback-2026-07-01"],
        fallbacks="default",
    )
    if response.stop_reason == "refusal":
        raise RuntimeError("Claude declined to answer that question.")
    return "".join(b.text for b in response.content if b.type == "text").strip()


def build_sql_system_prompt(schema, strategy):
    prompt = (
        "You translate questions about a homeschool co-op into SQLite queries.\n"
        "Here is the database schema:\n\n"
        f"{schema}\n\n"
        "Rules:\n"
        "- Reply with exactly one SQLite SELECT statement and nothing else.\n"
        "- Never modify data (no INSERT, UPDATE, DELETE, DROP, etc.).\n"
        "- Dates are stored as 'YYYY-MM-DD' text; use date('now') for today.\n"
        "- Course names (like 'Biology') are in course.subject.\n"
    )
    if strategy == "few-shot":
        prompt += "\n" + FEW_SHOT_EXAMPLE + "\n"
    return prompt


def extract_sql(text):
    """Pulls the SQL out of Claude's reply, dropping any ```sql fences."""
    match = re.search(r"```(?:sql)?\s*(.*?)```", text, re.DOTALL | re.IGNORECASE)
    return (match.group(1) if match else text).strip()


def run_query(sql):
    # Opened read-only, so even a bad query can't change the data
    conn = sqlite3.connect(f"file:{DB_PATH}?mode=ro", uri=True)
    try:
        cursor = conn.execute(sql)
        columns = [d[0] for d in cursor.description] if cursor.description else []
        rows = cursor.fetchmany(MAX_RESULT_ROWS)
        return columns, rows
    finally:
        conn.close()


def answer_question(client, question, sql_system):
    sql = extract_sql(ask_claude(client, sql_system, question))
    try:
        columns, rows = run_query(sql)
    except sqlite3.Error as e:
        # Give Claude one chance to fix its query using the error message
        retry = (f"{question}\n\nYour previous query:\n{sql}\n"
                 f"failed with this SQLite error: {e}\nWrite a corrected query.")
        sql = extract_sql(ask_claude(client, sql_system, retry))
        columns, rows = run_query(sql)

    result = json.dumps({"columns": columns, "rows": rows}, default=str)
    answer = ask_claude(
        client,
        "You answer questions about a homeschool co-op using database results. "
        "Answer in plain, friendly English in one to three sentences. "
        "Write plain text with no markdown, since this prints in a terminal. "
        "Don't mention SQL, tables or the database. If the results are empty, say "
        "no matching records were found.",
        f"Question: {question}\nSQL used: {sql}\nResults: {result}",
    )
    return sql, answer


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--strategy", choices=["zero-shot", "few-shot"], default="few-shot")
    args = parser.parse_args()

    if not os.path.exists(DB_PATH):
        raise SystemExit("homeschool.db not found. Run `python setup_db.py` first.")
    with open(SCHEMA_PATH, encoding="utf-8") as f:
        schema = f.read()

    client = load_client()
    sql_system = build_sql_system_prompt(schema, args.strategy)

    print(f"Homeschool co-op Q&A ({args.strategy}). Type 'quit' to exit.\n")
    while True:
        try:
            question = input("Question: ").strip()
        except (EOFError, KeyboardInterrupt):
            print()
            break
        if question.lower() in ("quit", "exit", "q"):
            break
        if not question:
            continue
        try:
            sql, answer = answer_question(client, question, sql_system)
            print(f"\nSQL: {sql}\n\nAnswer: {answer}\n")
        except (sqlite3.Error, RuntimeError, anthropic.APIError) as e:
            print(f"\nSorry, something went wrong: {e}\n")


if __name__ == "__main__":
    main()
