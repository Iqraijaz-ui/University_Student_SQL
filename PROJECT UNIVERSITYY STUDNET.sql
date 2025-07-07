CREATE DATABASE Student;
DROP DATABASE Student;
Use Student;
Drop Table university_students;

CREATE TABLE university_students (
    student_id TEXT,
    enrollment_year INT,
    major TEXT,
    minor TEXT,
    department TEXT,
    academic_level TEXT,
    current_semester INT,
    gpa NUMERIC(3,2),
    semester_gpa NUMERIC(3,2),
    credits_earned INT,
    credits_required INT,
    course_enrollment TEXT,
    status TEXT,
    expected_graduation_year INT,
    first_name TEXT,
    last_name TEXT,
    date_of_birth DATE,
    gender TEXT,
    nationality TEXT,
    ethnicity TEXT,
    student_type TEXT,
    email_address TEXT,
    tuition_status TEXT,
    scholarship_eligibility TEXT,
    scholarship_amount INT,
    financial_aid_status TEXT,
    fee_balance NUMERIC(10,2),
    admission_id TEXT,
    admission_type TEXT,
    high_school_gpa NUMERIC(3,2),
    admission_test_score INT,
    application_date DATE,
    admission_date DATE,
    on_campus_housing TEXT,
    student_clubs TEXT,
    club_memberships INT,
    sports_teams TEXT,
    volunteer_hours INT,
    internships_participated INT,
    events_attended INT,
    internship_company TEXT,
    graduation_employment_status TEXT,
    job_title TEXT,
    employer TEXT,
    starting_salary NUMERIC(10,2),
    date_created TIMESTAMP,
    last_updated TIMESTAMP,
    data_source TEXT
);
-- 1 What is the average GPA by department or major.
SELECT 
    department,
    major,
    ROUND(AVG(gpa), 2) AS avg_gpa
FROM 
    university_students
GROUP BY 
    department, major
ORDER BY 
    avg_gpa DESC;
-- 2 Which majors have the highest-performing students (GPA > 3.5)?
SELECT 
    major,
    COUNT(*) AS high_achievers,
    ROUND(AVG(gpa), 2) AS avg_gpa
FROM 
    university_students
WHERE 
    gpa > 3.5
GROUP BY 
    major
ORDER BY 
    avg_gpa DESC
   --  3How does GPA correlate with credit hours earned?



SELECT 
    credits_earned,
    ROUND(AVG(gpa), 2) AS avg_gpa,
    COUNT(*) AS student_count
FROM 
    university_students
GROUP BY 
    credits_earned
ORDER BY 
    credits_earned;

-- 4How many students are in each academic level (Undergraduate vs Postgraduate)
SELECT 
    academic_level,
    COUNT(*) AS student_count
FROM 
    university_students
GROUP BY 
    academic_level;
-- 5Count of student per year

SELECT 
    enrollment_year,
    COUNT(*) AS student_count
FROM 
    university_students
GROUP BY 
    enrollment_year
ORDER BY 
    enrollment_year;

-- 6Are students graduating within 4 years of enrollment?
SELECT 
    CASE 
        WHEN expected_graduation_year - enrollment_year <= 4 THEN 'On Time'
        ELSE 'Delayed'
    END AS graduation_timing,
    COUNT(*) AS student_count
FROM 
    university_students
GROUP BY 
    graduation_timing;
-- 7What is the most common expected graduation year?

SELECT 
    expected_graduation_year,
    COUNT(*) AS student_count
FROM 
    university_students
GROUP BY 
    expected_graduation_year
ORDER BY 
    student_count DESC
LIMIT 1;


-- 8Which departments receive the highest total scholarship funding?


SELECT 
    department,
    status,
    COUNT(*) AS student_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY department), 2) AS percentage
FROM 
    university_students
GROUP BY 
    department, status
ORDER BY 
    department, percentage DESC;
-- 9What’s the average fee balance by academic level?
SELECT 
    academic_level,
    ROUND(AVG(fee_balance), 2) AS avg_fee_balance
FROM 
    university_students
GROUP BY 
    academic_level;
-- 10Top internship Companies by student count
SELECT 
    internship_company,
    COUNT(*) AS intern_count
FROM 
    university_students
WHERE 
    internship_company IS NOT NULL AND internship_company <> ''
GROUP BY 
    internship_company
ORDER BY 
    intern_count DESC
LIMIT 10;
-- 11What is the average starting salary by major?
SELECT 
    major,
    ROUND(AVG(starting_salary), 2) AS avg_starting_salary
FROM 
    university_students
GROUP BY 
    major
ORDER BY 
    avg_starting_salary DESC;
--  12Graduate Outcomes: Employed vs Continuing Education

SELECT 
    graduation_employment_status,
    COUNT(*) AS graduate_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM university_students WHERE graduation_employment_status IS NOT NULL), 2) AS percentage
FROM 
    university_students
GROUP BY 
    graduation_employment_status;
-- 13Clubs with the Most Members
SELECT 
    student_clubs,
    COUNT(*) AS member_count
FROM 
    university_students
WHERE 
    student_clubs IS NOT NULL AND student_clubs <> ''
GROUP BY 
    student_clubs
ORDER BY 
    member_count DESC;
-- 14Average Number of Events Attended per Student
SELECT 
    ROUND(AVG(events_attended), 2) AS avg_events_attended
FROM 
    university_students;
-- 15Which majors have the highest student retention from 1st to final semester

SELECT 
    major,
    ROUND(AVG(current_semester), 1) AS avg_semester,
    ROUND(AVG(credits_earned), 1) AS avg_credits,
    COUNT(*) AS student_count
FROM 
    university_students
WHERE 
    major IS NOT NULL
GROUP BY 
    major
ORDER BY 
    avg_semester DESC, avg_credits DESC;
-- 16 does event participation affect academic performance?
SELECT 
    CASE 
        WHEN events_attended <= 3 THEN 'Low (0–3)'
        WHEN events_attended BETWEEN 4 AND 7 THEN 'Medium (4–7)'
        WHEN events_attended > 7 THEN 'High (8+)'
        ELSE 'Unknown'
    END AS event_participation_level,
    ROUND(AVG(gpa), 2) AS avg_gpa,
    COUNT(*) AS student_count
FROM 
    university_students
WHERE 
    gpa IS NOT NULL AND events_attended IS NOT NULL
GROUP BY 
    event_participation_level
ORDER BY 
    avg_gpa DESC;
