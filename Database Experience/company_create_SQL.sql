DROP DATABASE IF EXISTS COMPANY;
CREATE SCHEMA COMPANY;
USE COMPANY;

CREATE TABLE IF NOT EXISTS COMPANY.EMPLOYEE(
	F_NAME VARCHAR(20) NOT NULL,
    M_INIT CHAR,
    L_NAME VARCHAR(20) NOT NULL,
    SSN CHAR(9) NOT NULL,
    B_DATE DATE,
    ADDRESS VARCHAR(30),
    SEX CHAR,
    SALARY DECIMAL(10,2),
    SUPER_SSN CHAR(9),
    D_NO INT NOT NULL,
    CONSTRAINT CHK_EMPLOYEE_SALARY CHECK (SALARY > 2000.0), 
    PRIMARY KEY (SSN)
);


DROP TABLE IF EXISTS COMPANY.DEPARTAMENT;
CREATE TABLE IF NOT EXISTS COMPANY.DEPARTAMENT(
	D_NAME VARCHAR(15) NOT NULL,
    D_NUMBER INT NOT NULL,
    MGR_SSN CHAR(9),
    MGR_START_DATE DATE,
    DEPT_CREATE_DATE DATE,
    CONSTRAINT CHK_DEPARTAMENT_MGRSTARTDATE CHECK (DEPT_CREATE_DATE < MGR_START_DATE),
    CONSTRAINT PK_DEPT PRIMARY KEY (D_NUMBER),
    CONSTRAINT U_DEPARTAMENT_NAME UNIQUE (D_NAME),
    CONSTRAINT FK_DEPARTAMENT_EMPLOYEE FOREIGN KEY (MGR_SSN) REFERENCES EMPLOYEE(SSN) ON UPDATE CASCADE ON DELETE CASCADE

);

DESC DEPARTAMENT;

CREATE TABLE IF NOT EXISTS COMPANY.DEPT_LOCATIONS(
	D_NUMBER INT NOT NULL,
    D_LOCATION VARCHAR(15) NOT NULL,
    PRIMARY KEY (D_NUMBER, D_LOCATION),
    CONSTRAINT FK_DEPTLOCATIONS_DEPARTAMENT FOREIGN KEY (D_NUMBER) REFERENCES DEPARTAMENT(D_NUMBER)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS COMPANY.PROJECT(
	P_NAME VARCHAR(15) NOT NULL,
    P_NUMBER INT NOT NULL,
    P_LOCATION VARCHAR(15),
    D_NUM INT NOT NULL,
    PRIMARY KEY (P_NUMBER),
    CONSTRAINT U_PROJECT_PNAME UNIQUE (P_NAME),
    CONSTRAINT FK_PROJECT_DEPARTAMENT FOREIGN KEY (D_NUM) REFERENCES DEPARTAMENT(D_NUMBER) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS COMPANY.WORKS_ON(
		E_SSN CHAR(9) NOT NULL,
        P_NO INT NOT NULL,
        HOURS DECIMAL(3,1) NOT NULL,
        PRIMARY KEY (E_SSN, P_NO),
        CONSTRAINT FK_WORKSON_EMPLOYEE FOREIGN KEY (E_SSN) REFERENCES EMPLOYEE(SSN) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT FK_WORKSON_PROJECT FOREIGN KEY (P_NO) REFERENCES PROJECT(P_NUMBER) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS COMPANY.DEPENDENTS(
	E_SSN CHAR(9) NOT NULL,
    DEPENDENT_NAME VARCHAR(15) NOT NULL,
    SEX CHAR,
    B_DATE DATE,
    RELATIOSHIP VARCHAR(8),
    AGE INT NOT NULL,
    PRIMARY KEY (E_SSN, DEPENDENT_NAME),
    CONSTRAINT CHK_DEPENDENTS_AGE CHECK(AGE < 22),
    CONSTRAINT FK_DEPENDENTS_EMPLOYEE FOREIGN KEY (E_SSN) REFERENCES EMPLOYEE(SSN) ON UPDATE CASCADE ON DELETE CASCADE
);

SHOW TABLES FROM COMPANY;

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
	WHERE CONSTRAINT_SCHEMA = 'COMPANY' AND
    CONSTRAINT_NAME LIKE '%DEPARTAMENT%' AND
    CONSTRAINT_NAME LIKE '%FK%';

-- MODIFICAR UMA CONSTRAINT

ALTER TABLE DEPARTAMENT DROP CONSTRAINT FK_DEPARTAMENT_EMPLOYEE;
ALTER TABLE DEPARTAMENT
	ADD CONSTRAINT FK_DEPARTAMENT_EMPLOYEE FOREIGN KEY(MGR_SSN) REFERENCES EMPLOYEE(SSN)
    ON UPDATE CASCADE;

DROP TABLE DEPENDENTS;
CREATE TABLE IF NOT EXISTS COMPANY.DEPENDENTS(
	E_SSN CHAR(9) NOT NULL,
    DEPENDENT_NAME VARCHAR(15) NOT NULL,
    SEX CHAR,
    B_DATE DATE,
    RELATIONSHIP VARCHAR(8),
    PRIMARY KEY (E_SSN, DEPENDENT_NAME),
    CONSTRAINT FK_DEPENDENTS_EMPLOYEE FOREIGN KEY (E_SSN) REFERENCES EMPLOYEE(SSN) ON UPDATE CASCADE ON DELETE CASCADE
);