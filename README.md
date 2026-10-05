College-placement-system
🎓 College Placement Management System (MySQL)

A MySQL database project that manages the college placement process: students, departments, companies, jobs, applications, interviews, offers and student skills.

It shows, in one realistic project, the core SQL concepts: DDL, DML, DQL, Joins, Subqueries, Aggregation, Views and Indexes.

Developed by: Karthik

📑 Contents What this project does Database design (ER diagram) Tables explained Concepts covered Placement process How to run Sample queries Project structure 🎯 What this project does Stores student and department information Maintains company and job details Tracks every student application and its status Manages interview schedules and results Records job offers and packages Stores student skills with proficiency Generates placement reports using SQL queries

Sample data loaded by the script

Table Records Department 6 Student 12 Company 8 Job 8 Application 15 Interview 7 Offer 5 Skill 10 Student_Skill 36

Business rules built into the database

Rule Where it is enforced CGPA must be between 0 and 10 CHECK on Student and Job Package and vacancies must be greater than 0 CHECK on Job and Offer A student can apply to a job only once UNIQUE (student_id, job_id) on Application An application can have only one offer UNIQUE on Offer.application_id Roll number, email, department and company names are unique UNIQUE constraints New applications start as APPLIED DEFAULT on Application.status

🧱 Tables explained Table Purpose Key columns Department Academic departments department_id, department_name Student Student profile and CGPA student_id, roll_no, cgpa, department_id Company Recruiting companies company_id, company_name, industry, location Job Job openings with eligibility and package job_id, company_id, minimum_cgpa, package_lpa, vacancies Application Which student applied to which job application_id, student_id, job_id, status Interview Interview rounds for an application interview_id, application_id, interview_round, interview_status Offer Offer made for an application offer_id, application_id, offered_package_lpa, offer_status Skill List of skills skill_id, skill_name Student_Skill Links students to skills (many-to-many) student_id, skill_id, proficiency

Reports available

Students based on CGPA Companies by location Jobs based on package Students and their departments Student applications Company-wise application count Highest package Department-wise placement statistics Average package by company Students eligible for jobs Interview reports Students with specific skills Overall placement summary 🔄 Placement process No Yes SCHEDULED PASSED Accepts Pending Student applies for a job Application saved asAPPLIED Shortlisted? REJECTED Status becomesSHORTLISTED Interview scheduled Interview result Offer created Student decision ACCEPTED OFFERED

Why these checks? The CHECK and UNIQUE constraints keep the data valid: no duplicate applications, no invalid CGPA and no negative packages.

▶️ How to run

Requirement: MySQL Server and a terminal or MySQL client (macOS, Linux or Windows). Developed and tested on macOS with Apple Silicon.

Option 1: Command line

bash git clone https://github.com/YOUR-USERNAME/college-placement-management-system-mysql.git cd college-placement-management-system-mysql mysql -u root -p < college_placement.sql

Option 2: MySQL Workbench

Open MySQL Workbench and connect to your server. Go to File → Open SQL Script and choose college_placement.sql. Click the ⚡ Execute button.

The script creates a database called college_placement, with all tables, sample data, indexes and the view.

⚠️ The script starts with DROP DATABASE IF EXISTS college_placement;, so running it again resets the database.

🔍 Sample queries

After running the script, try these:

sql USE college_placement;

-- Check the tables SHOW TABLES;

-- Students with CGPA above 8 SELECT student_name, cgpa FROM Student WHERE cgpa > 8;

-- Overall placement summary SELECT * FROM Placement_Summary;

-- Highest package and who received it SELECT s.student_name, c.company_name, o.offered_package_lpa FROM Offer o JOIN Application a ON o.application_id = a.application_id JOIN Student s ON a.student_id = s.student_id JOIN Job j ON a.job_id = j.job_id JOIN Company c ON j.company_id = c.company_id WHERE o.offered_package_lpa = (SELECT MAX(offered_package_lpa) FROM Offer);

All 13 reports are written out in full in college_placement.sql.

📁 Project structure College_Placement-main/ ├── README.md ├── college_placement.sql # full project: tables, data, queries, view, indexes ├── er_diagram.png # ER diagram └── PPT.pptx # project presentation 🎓 Academic use

This project was developed as a DBMS/MySQL academic project to demonstrate practical implementation of relational database concepts.
