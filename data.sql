-- Sample data for the homeschool co-op database

INSERT INTO teacher (teacher_id, subject, full_name) VALUES
(1, 'Math',               'Sarah Thompson'),
(2, 'Science',            'David Nguyen'),
(3, 'Spanish',            'Maria Garcia'),
(4, 'History',            'James Carter'),
(5, 'English',            'Emily Johnson'),
(6, 'Music',              'Robert Kim'),
(7, 'Art',                'Linda Patel'),
(8, 'Physical Education', 'Michael Brown');

INSERT INTO student (student_id, full_name, grade_level) VALUES
(1,  'Emma Wilson',      9),
(2,  'Liam Anderson',    8),
(3,  'Olivia Martinez', 10),
(4,  'Noah Taylor',      7),
(5,  'Ava Thomas',       6),
(6,  'Ethan Moore',      9),
(7,  'Sophia Jackson',   5),
(8,  'Mason White',     10),
(9,  'Isabella Harris',  8),
(10, 'Lucas Martin',     6),
(11, 'Mia Clark',        7),
(12, 'Logan Lewis',      9),
(13, 'Charlotte Walker', 5),
(14, 'Elijah Hall',     10),
(15, 'Amelia Allen',     8),
(16, 'James Young',      6),
(17, 'Harper King',      7),
(18, 'Benjamin Wright',  9),
(19, 'Evelyn Scott',     5),
(20, 'Henry Green',     10);

INSERT INTO course (course_id, subject, grade_level) VALUES
(1,  'Algebra I',          9),
(2,  'Pre-Algebra',        7),
(3,  'Biology',            9),
(4,  'Earth Science',      6),
(5,  'Spanish I',          8),
(6,  'American History',  10),
(7,  'English Literature',10),
(8,  'Piano Fundamentals', 5),
(9,  'Drawing & Painting', 6),
(10, 'Physical Education', 7);

INSERT INTO textbook (textbook_id, title, author, subject) VALUES
(1,  'Algebra Made Clear',                          'Karen Whitfield', 'Math'),
(2,  'Foundations of Pre-Algebra',                  'Thomas Reyes',    'Math'),
(3,  'Living Systems: An Introduction to Biology',  'Alan Brooks',     'Science'),
(4,  'Our Dynamic Earth',                           'Rachel Simmons',  'Science'),
(5,  'Hablemos! Spanish Level 1',                   'Lucia Fernandez', 'Spanish'),
(6,  'A Nation Takes Shape: American History',      'George Whitman',  'History'),
(7,  'Classic Voices: An English Literature Anthology', 'Margaret Ellis', 'English'),
(8,  'First Steps at the Piano',                    'Hannah Becker',   'Music'),
(9,  'The Young Artist''s Sketchbook',              'Oliver Grant',    'Art'),
(10, 'Healthy Bodies, Active Lives',                'Samuel Ortiz',    'Physical Education'),
(11, 'Writing Strong Essays',                       'Margaret Ellis',  'English');

-- Courses 6 (History) and 10 (PE) are co-taught
INSERT INTO course_teacher (teacher_id, course_id) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5),
(4, 6), (5, 6),
(5, 7),
(6, 8),
(7, 9),
(8, 10), (2, 10);

INSERT INTO course_student (student_id, course_id, grade) VALUES
-- 9th graders
(1, 1, 'A'),  (1, 3, 'A-'),  (1, 5, 'B+'),
(6, 1, 'B'),  (6, 3, 'B+'),  (6, 10, 'A'),
(12, 1, 'C+'), (12, 3, 'B-'), (12, 9, 'A-'),
(18, 1, 'A-'), (18, 3, 'A'),  (18, 5, 'B'),
-- 10th graders
(3, 6, 'A'),  (3, 7, 'A'),   (3, 1, 'B+'),
(8, 6, 'B'),  (8, 7, 'B-'),  (8, 10, 'A-'),
(14, 6, 'C'), (14, 7, 'B'),  (14, 3, 'B'),
(20, 6, 'A-'), (20, 7, 'B+'), (20, 5, 'A'),
-- 8th graders
(2, 5, 'B'),  (2, 2, 'A-'),  (2, 10, 'B+'),
(9, 5, 'A'),  (9, 2, 'A'),   (9, 8, 'A-'),
(15, 5, 'C+'), (15, 2, 'B'),  (15, 9, 'B+'),
-- 7th graders
(4, 2, 'B-'), (4, 10, 'A'),  (4, 4, 'B'),
(11, 2, 'A'), (11, 10, 'B+'), (11, 9, 'A'),
(17, 2, 'B+'), (17, 10, 'A-'), (17, 8, 'B'),
-- 6th graders
(5, 4, 'A'),  (5, 9, 'A-'),  (5, 8, 'B+'),
(10, 4, 'B'), (10, 9, 'B'),  (10, 10, 'A'),
(16, 4, 'C+'), (16, 9, 'A'),  (16, 8, 'B-'),
-- 5th graders
(7, 8, 'A'),  (7, 4, 'B+'),
(13, 8, 'B'), (13, 4, 'A-'), (13, 9, 'A'),
(19, 8, 'A-'), (19, 4, 'B');

INSERT INTO course_textbook_teacher (course_id, teacher_id, textbook_id) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(5, 3, 5),
(6, 4, 6), (6, 5, 11),
(7, 5, 7), (7, 5, 11),
(8, 6, 8),
(9, 7, 9),
(10, 8, 10), (10, 2, 10);

INSERT INTO lesson_plan (lesson_id, topic, lesson_date, title) VALUES
(1,  'Linear Equations',    '2026-09-08', 'Solving One-Step Equations'),
(2,  'Linear Equations',    '2026-09-15', 'Multi-Step Equations'),
(3,  'Graphing',            '2026-09-22', 'Slope and Intercept'),
(4,  'Fractions',           '2026-09-09', 'Adding and Subtracting Fractions'),
(5,  'Ratios',              '2026-09-23', 'Ratios and Proportions'),
(6,  'Cells',               '2026-09-10', 'Parts of the Cell'),
(7,  'Cells',               '2026-09-17', 'Mitosis and Cell Division'),
(8,  'Genetics',            '2026-10-01', 'Introduction to Punnett Squares'),
(9,  'Rocks and Minerals',  '2026-09-11', 'The Rock Cycle'),
(10, 'Weather',             '2026-10-02', 'Clouds and Precipitation'),
(11, 'Vocabulary',          '2026-09-08', 'Greetings and Introductions'),
(12, 'Grammar',             '2026-09-29', 'Present Tense -AR Verbs'),
(13, 'Colonial America',    '2026-09-09', 'The Thirteen Colonies'),
(14, 'Revolution',          '2026-09-30', 'Causes of the American Revolution'),
(15, 'Founding Documents',  '2026-10-14', 'The Declaration of Independence'),
(16, 'Poetry',              '2026-09-10', 'Reading Sonnets'),
(17, 'Novels',              '2026-10-01', 'Themes in To Kill a Mockingbird'),
(18, 'Writing',             '2026-10-15', 'Writing a Persuasive Essay'),
(19, 'Rhythm',              '2026-09-11', 'Quarter and Half Notes'),
(20, 'Scales',              '2026-10-09', 'The C Major Scale'),
(21, 'Color Theory',        '2026-09-12', 'The Color Wheel'),
(22, 'Drawing',             '2026-10-10', 'Shading and Perspective'),
(23, 'Fitness',             '2026-09-14', 'Building Endurance'),
(24, 'Team Sports',         '2026-10-05', 'Soccer Basics'),
(25, 'Primary Sources',     '2026-10-21', 'Letters from the Revolutionary War'),
(26, 'Systems of Equations','2026-10-27', 'Solving Systems by Substitution'),
(27, 'Weather',             '2026-10-30', 'Reading a Weather Map');

-- Lessons 5 and 25 are shared between two courses
INSERT INTO lesson_course (lesson_id, course_id) VALUES
(1, 1), (2, 1), (3, 1), (26, 1),
(4, 2), (5, 2), (5, 1),
(6, 3), (7, 3), (8, 3),
(9, 4), (10, 4), (27, 4),
(11, 5), (12, 5),
(13, 6), (14, 6), (15, 6), (25, 6),
(16, 7), (17, 7), (18, 7), (25, 7),
(19, 8), (20, 8),
(21, 9), (22, 9),
(23, 10), (24, 10);
