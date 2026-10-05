/* ---------------------------------------------------------------
   Project      : College Placement Management System (MySQL)
   Developed by : Karthik
   Database     : MySQL 8.0+ (developed and tested on MySQL 9.7.1, macOS)
   Concepts     : DDL, DML, DQL, Joins, Subqueries, Aggregation,
                  Views, Indexes
   Run          : mysql -u root -p < college_placement.sql
   --------------------------------------------------------------- */

-- ===== 1. DDL (Data Definition Language) =====
DROP DATABASE IF EXISTS college_placement;
CREATE DATABASE college_placement;
USE college_placement;

CREATE TABLE Department (
    department_id   INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Student (
    student_id      INT AUTO_INCREMENT PRIMARY KEY,
    roll_no         VARCHAR(20) NOT NULL UNIQUE,
    student_name    VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE,
    phone           VARCHAR(15),
    cgpa            DECIMAL(3,2),
    graduation_year YEAR,
    department_id   INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    CHECK (cgpa BETWEEN 0 AND 10)
);

CREATE TABLE Company (
    company_id   INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL UNIQUE,
    industry     VARCHAR(100),
    location     VARCHAR(100)
);

CREATE TABLE Job (
    job_id               INT AUTO_INCREMENT PRIMARY KEY,
    company_id           INT NOT NULL,
    job_role             VARCHAR(100) NOT NULL,
    job_type             VARCHAR(50),
    minimum_cgpa         DECIMAL(3,2),
    package_lpa          DECIMAL(6,2),
    vacancies            INT,
    application_deadline DATE,
    FOREIGN KEY (company_id) REFERENCES Company(company_id),
    CHECK (minimum_cgpa BETWEEN 0 AND 10),
    CHECK (package_lpa > 0),
    CHECK (vacancies > 0)
);

CREATE TABLE Application (
    application_id   INT AUTO_INCREMENT PRIMARY KEY,
    student_id       INT NOT NULL,
    job_id           INT NOT NULL,
    application_date DATE NOT NULL,
    status           VARCHAR(30) DEFAULT 'APPLIED',
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (job_id) REFERENCES Job(job_id),
    UNIQUE (student_id, job_id)
);

CREATE TABLE Interview (
    interview_id     INT AUTO_INCREMENT PRIMARY KEY,
    application_id   INT NOT NULL,
    interview_date   DATE NOT NULL,
    interview_round  VARCHAR(50),
    interview_status VARCHAR(30),
    FOREIGN KEY (application_id) REFERENCES Application(application_id)
);

CREATE TABLE Offer (
    offer_id            INT AUTO_INCREMENT PRIMARY KEY,
    application_id      INT NOT NULL UNIQUE,
    offer_date          DATE NOT NULL,
    offered_package_lpa DECIMAL(6,2),
    offer_status        VARCHAR(30) DEFAULT 'OFFERED',
    FOREIGN KEY (application_id) REFERENCES Application(application_id),
    CHECK (offered_package_lpa > 0)
);

CREATE TABLE Skill (
    skill_id   INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Student_Skill (
    student_id  INT NOT NULL,
    skill_id    INT NOT NULL,
    proficiency VARCHAR(30),
    PRIMARY KEY (student_id, skill_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id)
);

-- Indexes to speed up CGPA and package searches
CREATE INDEX idx_student_cgpa ON Student(cgpa);
CREATE INDEX idx_job_package  ON Job(package_lpa);

-- ===== 2. DML (Data Manipulation Language) =====
INSERT INTO Department (department_name) VALUES
('Computer Science and Engineering'),
('Artificial Intelligence and Machine Learning'),
('Information Technology'),
('Electronics and Communication Engineering'),
('Electrical and Electronics Engineering'),
('Mechanical Engineering');

INSERT INTO Student (roll_no, student_name, email, phone, cgpa, graduation_year, department_id) VALUES
('IARE001', 'Karthik', 'karthik@example.com', '9876543201', 8.20, 2026, 1),
('IARE002', 'Rahul',   'rahul@example.com',   '9876543202', 7.60, 2026, 1),
('IARE003', 'Sneha',   'sneha@example.com',   '9876543203', 8.70, 2026, 2),
('IARE004', 'Arjun',   'arjun@example.com',   '9876543204', 7.20, 2026, 3),
('IARE005', 'Priya',   'priya@example.com',   '9876543205', 9.10, 2026, 2),
('IARE006', 'Vikram',  'vikram@example.com',  '9876543206', 6.80, 2026, 4),
('IARE007', 'Ananya',  'ananya@example.com',  '9876543207', 8.50, 2026, 1),
('IARE008', 'Rohit',   'rohit@example.com',   '9876543208', 7.00, 2026, 3),
('IARE009', 'Meena',   'meena@example.com',   '9876543209', 7.80, 2026, 5),
('IARE010', 'Sanjay',  'sanjay@example.com',  '9876543210', 6.50, 2026, 6),
('IARE011', 'Divya',   'divya@example.com',   '9876543211', 8.90, 2026, 2),
('IARE012', 'Aditya',  'aditya@example.com',  '9876543212', 7.40, 2026, 1);

INSERT INTO Company (company_name, industry, location) VALUES
('TCS',           'Information Technology',    'Hyderabad'),
('Infosys',       'Information Technology',    'Hyderabad'),
('Wipro',         'Information Technology',    'Bangalore'),
('Accenture',     'Information Technology',    'Hyderabad'),
('Deloitte',      'Consulting and Technology', 'Hyderabad'),
('Cognizant',     'Information Technology',    'Pune'),
('Amazon',        'E-Commerce and Technology', 'Bangalore'),
('Tech Mahindra', 'Information Technology',    'Hyderabad');

INSERT INTO Job (company_id, job_role, job_type, minimum_cgpa, package_lpa, vacancies, application_deadline) VALUES
(1, 'Software Engineer',            'Full Time', 7.00,  7.50, 15, '2026-10-15'),
(2, 'Systems Engineer',             'Full Time', 6.50,  6.80, 20, '2026-10-20'),
(3, 'Project Engineer',             'Full Time', 6.00,  5.50, 25, '2026-10-18'),
(4, 'Associate Software Engineer',  'Full Time', 7.00,  7.20, 15, '2026-10-25'),
(5, 'Analyst',                      'Full Time', 7.50,  8.00, 10, '2026-10-22'),
(6, 'Programmer Analyst',           'Full Time', 6.50,  6.00, 20, '2026-10-28'),
(7, 'Data Analyst',                 'Full Time', 8.00, 12.00,  5, '2026-10-30'),
(8, 'Software Developer',           'Full Time', 7.00,  6.50, 12, '2026-10-26');

INSERT INTO Application (student_id, job_id, application_date, status) VALUES
(1,  1, '2026-09-20', 'APPLIED'),
(1,  4, '2026-09-21', 'SHORTLISTED'),
(2,  2, '2026-09-20', 'APPLIED'),
(3,  7, '2026-09-22', 'SHORTLISTED'),
(3,  1, '2026-09-23', 'APPLIED'),
(4,  3, '2026-09-21', 'REJECTED'),
(5,  7, '2026-09-22', 'SHORTLISTED'),
(5,  5, '2026-09-23', 'APPLIED'),
(6,  6, '2026-09-24', 'APPLIED'),
(7,  1, '2026-09-24', 'SHORTLISTED'),
(8,  8, '2026-09-24', 'APPLIED'),
(9,  5, '2026-09-25', 'APPLIED'),
(10, 3, '2026-09-25', 'REJECTED'),
(11, 7, '2026-09-25', 'SHORTLISTED'),
(12, 4, '2026-09-26', 'APPLIED');

INSERT INTO Interview (application_id, interview_date, interview_round, interview_status) VALUES
(2,  '2026-10-02', 'Technical', 'PASSED'),
(4,  '2026-10-03', 'Technical', 'PASSED'),
(7,  '2026-10-04', 'Technical', 'PASSED'),
(9,  '2026-10-05', 'Technical', 'SCHEDULED'),
(10, '2026-10-06', 'Technical', 'PASSED'),
(11, '2026-10-07', 'HR',        'SCHEDULED'),
(14, '2026-10-08', 'Technical', 'SCHEDULED');

INSERT INTO Offer (application_id, offer_date, offered_package_lpa, offer_status) VALUES
(2,  '2026-10-10',  7.20, 'ACCEPTED'),
(4,  '2026-10-11', 12.00, 'ACCEPTED'),
(7,  '2026-10-12',  8.00, 'OFFERED'),
(10, '2026-10-13',  7.50, 'ACCEPTED'),
(14, '2026-10-14',  6.50, 'OFFERED');

INSERT INTO Skill (skill_name) VALUES
('Java'), ('Python'), ('SQL'), ('HTML'), ('CSS'),
('JavaScript'), ('React'), ('Machine Learning'), ('Data Structures'), ('Git');

INSERT INTO Student_Skill (student_id, skill_id, proficiency) VALUES
(1, 1, 'Intermediate'), (1, 2, 'Advanced'),     (1, 3, 'Advanced'),     (1, 9, 'Intermediate'),
(2, 1, 'Intermediate'), (2, 3, 'Intermediate'), (2, 6, 'Intermediate'),
(3, 2, 'Advanced'),     (3, 8, 'Advanced'),     (3, 3, 'Advanced'),     (3, 9, 'Intermediate'),
(4, 1, 'Intermediate'), (4, 3, 'Advanced'),     (4, 6, 'Intermediate'),
(5, 2, 'Advanced'),     (5, 8, 'Advanced'),     (5, 7, 'Intermediate'),
(6, 1, 'Intermediate'), (6, 3, 'Intermediate'),
(7, 1, 'Advanced'),     (7, 6, 'Advanced'),     (7, 7, 'Intermediate'), (7, 9, 'Advanced'),
(8, 2, 'Intermediate'), (8, 3, 'Advanced'),     (8, 6, 'Intermediate'),
(9, 3, 'Advanced'),     (9, 8, 'Intermediate'),
(10, 1, 'Intermediate'), (10, 3, 'Intermediate'),
(11, 2, 'Advanced'),    (11, 8, 'Advanced'),    (11, 9, 'Advanced'),
(12, 1, 'Intermediate'), (12, 3, 'Advanced'),   (12, 10, 'Intermediate');

-- UPDATE : change a phone number and an application status
UPDATE Student     SET phone  = '9876500001'  WHERE student_id = 1;
UPDATE Application SET status = 'SHORTLISTED' WHERE application_id = 1;

-- INSERT then DELETE : add a test company and remove it again
INSERT INTO Company (company_name, industry, location) VALUES ('Test Company', 'Testing', 'Hyderabad');
DELETE FROM Company WHERE company_name = 'Test Company';

-- ===== 3. DQL (Data Query Language) =====
-- 3.1 Students with CGPA above 8
SELECT student_name, cgpa
FROM Student
WHERE cgpa > 8;

-- 3.2 Jobs paying more than 7 LPA
SELECT job_role, package_lpa, vacancies
FROM Job
WHERE package_lpa > 7;

-- 3.3 Companies located in Hyderabad
SELECT company_name, industry
FROM Company
WHERE location = 'Hyderabad';

-- ===== 4. JOINS =====
-- 4.1 Students with their departments
SELECT s.student_id, s.student_name, s.cgpa, d.department_name
FROM Student s
JOIN Department d ON s.department_id = d.department_id;

-- 4.2 Students ranked by CGPA (highest first)
SELECT s.student_name, s.cgpa, d.department_name
FROM Student s
JOIN Department d ON s.department_id = d.department_id
ORDER BY s.cgpa DESC;

-- 4.3 Multi-table JOIN : application report
SELECT a.application_id, s.student_name, c.company_name, j.job_role,
       a.application_date, a.status
FROM Application a
JOIN Student s ON a.student_id = s.student_id
JOIN Job     j ON a.job_id     = j.job_id
JOIN Company c ON j.company_id = c.company_id
ORDER BY a.application_date;

-- 4.4 Interview report
SELECT s.student_name, c.company_name, j.job_role,
       i.interview_date, i.interview_round, i.interview_status
FROM Interview i
JOIN Application a ON i.application_id = a.application_id
JOIN Student     s ON a.student_id     = s.student_id
JOIN Job         j ON a.job_id         = j.job_id
JOIN Company     c ON j.company_id     = c.company_id
ORDER BY i.interview_date;

-- 4.5 Offer report
SELECT s.student_name, c.company_name, j.job_role,
       o.offered_package_lpa, o.offer_status
FROM Offer o
JOIN Application a ON o.application_id = a.application_id
JOIN Student     s ON a.student_id     = s.student_id
JOIN Job         j ON a.job_id         = j.job_id
JOIN Company     c ON j.company_id     = c.company_id;

-- 4.6 Student skills with proficiency
SELECT s.student_name, sk.skill_name, ss.proficiency
FROM Student_Skill ss
JOIN Student s  ON ss.student_id = s.student_id
JOIN Skill   sk ON ss.skill_id   = sk.skill_id
ORDER BY s.student_name;

-- 4.7 Students who know Python
SELECT s.student_name, s.cgpa, ss.proficiency
FROM Student_Skill ss
JOIN Student s  ON ss.student_id = s.student_id
JOIN Skill   sk ON ss.skill_id   = sk.skill_id
WHERE sk.skill_name = 'Python';

-- 4.8 CROSS JOIN : every student matched with every job they are eligible for
SELECT s.student_name, s.cgpa, j.job_role, c.company_name, j.minimum_cgpa
FROM Student s
CROSS JOIN Job j
JOIN Company c ON j.company_id = c.company_id
WHERE s.cgpa >= j.minimum_cgpa
ORDER BY s.cgpa DESC;

-- ===== 5. SUBQUERIES =====
-- 5.1 Scalar subquery : student who received the highest package
SELECT s.student_name, c.company_name, j.job_role, o.offered_package_lpa
FROM Offer o
JOIN Application a ON o.application_id = a.application_id
JOIN Student     s ON a.student_id     = s.student_id
JOIN Job         j ON a.job_id         = j.job_id
JOIN Company     c ON j.company_id     = c.company_id
WHERE o.offered_package_lpa = (SELECT MAX(offered_package_lpa) FROM Offer);

-- ===== 6. AGGREGATION (GROUP BY and reports) =====
-- 6.1 Number of applications received by each company
SELECT c.company_name, COUNT(a.application_id) AS total_applications
FROM Company c
JOIN Job j         ON c.company_id = j.company_id
JOIN Application a ON j.job_id     = a.job_id
GROUP BY c.company_id, c.company_name
ORDER BY total_applications DESC;

-- 6.2 Highest package offered
SELECT MAX(offered_package_lpa) AS highest_package_lpa
FROM Offer;

-- 6.3 Department-wise placement statistics
SELECT d.department_name, COUNT(DISTINCT s.student_id) AS students_placed
FROM Offer o
JOIN Application a ON o.application_id = a.application_id
JOIN Student s     ON a.student_id     = s.student_id
JOIN Department d  ON s.department_id  = d.department_id
WHERE o.offer_status IN ('OFFERED', 'ACCEPTED')
GROUP BY d.department_id, d.department_name
ORDER BY students_placed DESC;

-- 6.4 Average offered package for each company
SELECT c.company_name, ROUND(AVG(o.offered_package_lpa), 2) AS average_package_lpa
FROM Offer o
JOIN Application a ON o.application_id = a.application_id
JOIN Job j         ON a.job_id         = j.job_id
JOIN Company c     ON j.company_id     = c.company_id
GROUP BY c.company_id, c.company_name
ORDER BY average_package_lpa DESC;

-- 6.5 Record count of every table (UNION ALL)
SELECT 'Department' AS table_name, COUNT(*) AS records FROM Department
UNION ALL SELECT 'Student',       COUNT(*) FROM Student
UNION ALL SELECT 'Company',       COUNT(*) FROM Company
UNION ALL SELECT 'Job',           COUNT(*) FROM Job
UNION ALL SELECT 'Application',   COUNT(*) FROM Application
UNION ALL SELECT 'Interview',     COUNT(*) FROM Interview
UNION ALL SELECT 'Offer',         COUNT(*) FROM Offer
UNION ALL SELECT 'Skill',         COUNT(*) FROM Skill
UNION ALL SELECT 'Student_Skill', COUNT(*) FROM Student_Skill;

-- ===== 7. VIEWS =====
-- 7.1 Overall placement summary (hides the 5-table join)
CREATE OR REPLACE VIEW Placement_Summary AS
SELECT s.student_name, d.department_name, c.company_name, j.job_role,
       o.offered_package_lpa, o.offer_status
FROM Offer o
JOIN Application a ON o.application_id = a.application_id
JOIN Student s     ON a.student_id     = s.student_id
JOIN Department d  ON s.department_id  = d.department_id
JOIN Job j         ON a.job_id         = j.job_id
JOIN Company c     ON j.company_id     = c.company_id;

SELECT * FROM Placement_Summary;

-- ===== 8. VERIFICATION (structure, constraints and indexes) =====
SHOW TABLES;
DESCRIBE Student;
SHOW INDEX FROM Student;
SHOW INDEX FROM Job;
