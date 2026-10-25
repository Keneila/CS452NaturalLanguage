-- Homeschool co-op database schema (SQLite)

CREATE TABLE teacher (
    teacher_id  INTEGER PRIMARY KEY,
    subject     VARCHAR(50)  NOT NULL,
    full_name   VARCHAR(100) NOT NULL
);

CREATE TABLE student (
    student_id  INTEGER PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    grade_level INTEGER      NOT NULL
);

CREATE TABLE course (
    course_id   INTEGER PRIMARY KEY,
    subject     VARCHAR(100) NOT NULL,
    grade_level INTEGER      NOT NULL
);

CREATE TABLE textbook (
    textbook_id INTEGER PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    author      VARCHAR(100) NOT NULL,
    subject     VARCHAR(50)  NOT NULL
);

CREATE TABLE lesson_plan (
    lesson_id   INTEGER PRIMARY KEY,
    topic       VARCHAR(100) NOT NULL,
    lesson_date DATE         NOT NULL,  -- stored as 'YYYY-MM-DD'
    title       VARCHAR(200) NOT NULL
);

-- Which teachers teach which courses (a course can be co-taught)
CREATE TABLE course_teacher (
    teacher_id  INTEGER NOT NULL REFERENCES teacher(teacher_id),
    course_id   INTEGER NOT NULL REFERENCES course(course_id),
    PRIMARY KEY (teacher_id, course_id)
);

-- Student enrollments, with the student's letter grade in the course
CREATE TABLE course_student (
    student_id  INTEGER NOT NULL REFERENCES student(student_id),
    course_id   INTEGER NOT NULL REFERENCES course(course_id),
    grade       CHAR(2),  -- letter grade such as 'A', 'B+', 'C-'
    PRIMARY KEY (student_id, course_id)
);

-- Which textbook a teacher uses for a course
CREATE TABLE course_textbook_teacher (
    course_id   INTEGER NOT NULL REFERENCES course(course_id),
    teacher_id  INTEGER NOT NULL REFERENCES teacher(teacher_id),
    textbook_id INTEGER NOT NULL REFERENCES textbook(textbook_id),
    PRIMARY KEY (course_id, teacher_id, textbook_id)
);

-- Which courses a lesson plan is used in
CREATE TABLE lesson_course (
    lesson_id   INTEGER NOT NULL REFERENCES lesson_plan(lesson_id),
    course_id   INTEGER NOT NULL REFERENCES course(course_id),
    PRIMARY KEY (lesson_id, course_id)
);
