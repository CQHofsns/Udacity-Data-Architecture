'''
CREATE TABLES, Plase refer to attached Schema
'''
CREATE TABLE employee (
    emp_ID VARCHAR(10) PRIMARY KEY,
    emp_nm VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE educationlvl (
    edulvl_ID SERIAL PRIMARY KEY,
    edulvl_nm VARCHAR(50)
);

CREATE TABLE job (
    job_ID SERIAL PRIMARY KEY,
    job_title VARCHAR(50)
);

CREATE TABLE department (
    dpm_ID SERIAL PRIMARY KEY,
    dpm_nm VARCHAR(50)
);

CREATE TABLE location (
    loc_ID SERIAL PRIMARY KEY,
    loc_nm VARCHAR(50),
    address VARCHAR,
    city VARCHAR(50),
    state VARCHAR(2)
);

CREATE TABLE salary (
    emp_ID VARCHAR(10),
    start_date DATE,
    salary INT,
    PRIMARY KEY (emp_ID, start_date)
);

CREATE TABLE boarding (
    emp_ID VARCHAR(10),
    mng_ID VARCHAR(10),
    edulvl_ID INT,
    job_ID INT,
    loc_ID INT,
    dpm_ID INT,
    start_date DATE,
    end_date DATE,
    hire_date DATE,
    PRIMARY KEY (emp_ID, start_date),
    FOREIGN KEY (emp_ID) REFERENCES employee (emp_ID),
    FOREIGN KEY (mng_ID) REFERENCES employee (emp_ID),
    FOREIGN KEY (emp_ID, start_date) REFERENCES salary (emp_ID, start_date),
    FOREIGN KEY (edulvl_ID) REFERENCES educationlvl (edulvl_ID),
    FOREIGN KEY (job_ID) REFERENCES job (job_ID),
    FOREIGN KEY (loc_ID) REFERENCES location (loc_ID),
    FOREIGN KEY (dpm_ID) REFERENCES department (dpm_ID)
);

'''
INSERT DATA
'''

INSERT INTO Employee (emp_ID, emp_nm, email)
SELECT DISTINCT 
    Emp_ID,
    Emp_NM,
    email
FROM
    proj_stg;


INSERT INTO educationlvl (edulvl_nm)
SELECT DISTINCT
    education_lvl
FROM
    proj_stg;
    

INSERT INTO job (job_title)
SELECT DISTINCT
    job_title
FROM
    proj_stg;


INSERT INTO department (dpm_nm)
SELECT DISTINCT
    department_nm
FROM
    proj_stg;


INSERT INTO location (loc_nm, address, city, state)
SELECT DISTINCT
    location,
    address,
    city,
    state
FROM
    proj_stg;
    

INSERT INTO salary (emp_ID, start_date, salary)
SELECT DISTINCT
    Emp_ID,
    start_dt,
    salary
FROM
    proj_stg;


INSERT INTO boarding (emp_ID, mng_ID, edulvl_ID, job_ID, loc_ID, dpm_ID, start_date, end_date, hire_date)
SELECT
    main.Emp_ID,
    emp.emp_ID,
    edu.edulvl_ID,
    job.job_ID,
    loc.loc_ID,
    dpm.dpm_ID,
    main.start_dt,
    main.end_dt,
    main.hire_dt
FROM
    proj_stg as main
LEFT JOIN employee AS emp ON emp.Emp_NM= main.manager
JOIN educationlvl AS edu ON edu.edulvl_nm= main.education_lvl
JOIN job ON job.job_title= main.job_title
JOIN location AS loc ON loc.loc_nm= main.location
JOIN department AS dpm ON dpm.dpm_nm= main.department_nm;