'''
Question queries section
Question 1
'''
SELECT DISTINCT
    e.emp_nm AS employee_name,
    jd.job_title AS job_title,
    jd.dpm_nm AS department
FROM
    employee as e
JOIN (
    SELECT
        b.emp_ID,
        b.job_ID,
        b.dpm_ID,
        j.job_title,
        d.dpm_nm
    FROM
        boarding AS b
    JOIN job AS j ON j.job_ID= b.job_ID
    JOIN department AS d ON d.dpm_ID= b.dpm_ID
) AS jd
ON e.emp_ID= jd.emp_ID;

'''
Question 2
'''
INSERT INTO job (job_title)
VALUES ('Web Programmer');

'''
Question 3
'''
UPDATE job
SET job_title= 'web developer'
WHERE job_title= 'Web Programmer';

'''
Question 4
'''
DELETE FROM job
WHERE job_title= 'web developer';

'''
Question 5
'''
SELECT 
    d.dpm_nm as deparment,
    COUNT(DISTINCT b.emp_ID) as number_employees
FROM
    boarding AS b
JOIN department AS d ON d.dpm_ID= b.dpm_ID
GROUP BY
    d.dpm_nm;

'''
Question 6
'''
SELECT DISTINCT
    e.emp_nm AS employee_name,
    jd.start_date AS start_date,
    jd.end_date AS end_date,
    jd.job_title AS job_title,
    jd.dpm_nm AS department
FROM
    employee as e
JOIN (
    SELECT
        b.emp_ID,
        b.job_ID,
        b.dpm_ID,
        b.start_date,
        b.end_date,
        j.job_title,
        d.dpm_nm
    FROM
        boarding AS b
    JOIN job AS j ON j.job_ID= b.job_ID
    JOIN department AS d ON d.dpm_ID= b.dpm_ID
) AS jd
ON e.emp_ID= jd.emp_ID
WHERE
    e.emp_nm= 'Toni Lembeck';