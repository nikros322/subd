CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE
);

CREATE TABLE subjects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    hours SMALLINT NOT NULL
);

CREATE TABLE marks (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    mark TINYINT NOT NULL CHECK (mark >= 2 AND mark <= 5),
    exam_date DATE DEFAULT CURRENT_DATE(),
    
    PRIMARY KEY (student_id, subject_id, exam_date),
    
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (subject_id) REFERENCES subjects(id)
);

INSERT INTO students (first_name, last_name, birth_date) VALUES
('Иван', 'Петров', '2000-05-15'),
('Мария', 'Сидорова', '2001-01-20'),
('Алексей', 'Козлов', '2000-11-30'),
('Елена', 'Иванова', '2002-03-10'),
('Дмитрий', 'Соколов', '2001-07-25'),
('Анна', 'Морозова', '2000-09-01'),
('Сергей', 'Волков', '2002-04-18'),
('Ольга', 'Зайцева', '2001-06-05'),
('Павел', 'Кузнецов', '2000-12-12'),
('Татьяна', 'Лебедева', '2002-02-28');

INSERT INTO subjects (name, hours) VALUES
('Математика', 120),
('Информатика', 90),
('История', 60),
('Физика', 100),
('Химия', 80),
('Физкультура', 40),
('Экономика', 75),
('Право', 50),
('Английский язык', 90),
('Философия', 45);

INSERT INTO marks (student_id, subject_id, mark, exam_date) VALUES
(1, 1, 5, '2025-12-05'),
(2, 1, 4, '2025-12-05'),
(3, 2, 5, '2025-12-06'),
(4, 3, 3, '2025-12-06'),
(5, 4, 4, '2025-12-07'),
(6, 5, 5, '2025-12-07'),
(7, 6, 5, '2025-12-08'),
(8, 7, 4, '2025-12-08'),
(9, 8, 3, '2025-12-09'),
(10, 9, 5, '2025-12-09');