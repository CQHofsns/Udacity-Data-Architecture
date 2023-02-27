'''
Suggestion 1
'''
CREATE VIEW Employee_all_info AS
SELECT
    main.emp_ID AS EMP_ID,
    emp.emp_nm AS EMP_NM,
    emp.email AS EMAIL,
    main.hire_date AS HIRE_DT,
    job.job_title AS JOB_TITLE,
    sal.salary AS SALARY,
    dpm.dpm_nm AS DEPARTMENT,
    mng.emp_nm AS MANAGER,
    main.start_date AS START_DATE,
    main.end_date AS END_DATE,
    loc.loc_nm AS LOCATION,
    loc.address AS ADDRESS,
    loc.city AS CITY,
    loc.state AS STATE,
    edu.edulvl_nm AS EDUCATION_LEVEL
FROM
    boarding AS main
JOIN employee AS emp ON emp.emp_ID= main.emp_ID
LEFT JOIN employee AS mng ON mng.emp_ID= main.mng_ID
JOIN educationlvl AS edu ON edu.edulvl_ID= main.edulvl_ID
JOIN job ON job.job_ID= main.job_ID
JOIN location AS loc ON loc.loc_ID= main.loc_ID
JOIN department AS dpm ON dpm.dpm_ID= main.dpm_ID
JOIN salary AS sal ON sal.emp_ID= main.emp_ID AND sal.start_date= main.start_date;

SELECT * FROM Employee_all_info;

'''
Suggestion 2
'''
CREATE OR REPLACE FUNCTION Employee_working_info(emp_name VARCHAR(50))
    RETURNS TABLE (
        employee_name VARCHAR(50),
        manager_name VARCHAR(50),
        start_date DATE,
        end_date DATE,
        job_title VARCHAR(50),
        department VARCHAR(50)
    )
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT
            e.emp_nm AS employee_name,
            jd.emp_nm AS manager,
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
                b.mng_ID,
                b.start_date,
                b.end_date,
                m.emp_nm,
                j.job_title,
                d.dpm_nm
            FROM
                boarding AS b
            LEFT JOIN employee AS m ON m.emp_ID= b.mng_ID
            JOIN job AS j ON j.job_ID= b.job_ID
            JOIN department AS d ON d.dpm_ID= b.dpm_ID
        ) AS jd
        ON e.emp_ID= jd.emp_ID
        WHERE e.emp_nm= emp_name;
END;
$$;

'''
Suggestion 3
'''
CREATE ROLE NoMgr LOGIN PASSWORD 'password1223';
GRANT ALL ON ALL TABLES IN SCHEMA "public" TO NoMgr;
REVOKE ALL ON salary FROM NoMgr;