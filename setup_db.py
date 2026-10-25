"""Builds homeschool.db from schema.sql and data.sql (deletes any existing copy first)."""
import os
import sqlite3

HERE = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(HERE, "homeschool.db")


def main():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)

    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")
    for name in ("schema.sql", "data.sql"):
        with open(os.path.join(HERE, name), encoding="utf-8") as f:
            conn.executescript(f.read())
    conn.commit()

    tables = [r[0] for r in conn.execute(
        "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name")]
    for table in tables:
        count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        print(f"{table:<25} {count} rows")
    conn.close()
    print(f"\nCreated {DB_PATH}")


if __name__ == "__main__":
    main()
