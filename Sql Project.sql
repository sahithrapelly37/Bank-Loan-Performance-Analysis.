CREATE DATABASE Project;

use project;

CREATE TABLE Finance_2(
	id	int,	delinq_2yrs int,	earliest_cr_line VARCHAR(100),	inq_last_6mths int,	mths_since_last_delinq VARCHAR(100),
    mths_since_last_record VARCHAR(100),	open_acc int,	pub_rec int,	revol_bal int,	revol_util VARCHAR(100),	total_acc int,	
    initial_list_status VARCHAR(100),	out_prncp int,	out_prncp_inv int, total_pymnt double, total_pymnt_inv double, 
    total_rec_prncp double,	total_rec_int double, total_rec_late_fee int,	recoveries int, collection_recovery_fee int, 
    last_pymnt_d varchar(30),	last_pymnt_amnt double,	next_pymnt_d  VARCHAR(100),	last_credit_pull_d  VARCHAR(100));
    
Describe Finance_2;
    
SELECT @@secure_file_priv;

-- C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\
    
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Finance_2.csv" 
INTO TABLE Finance_2 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM finance_2;

CREATE TABLE Finance_1(
	id int,	member_id int,	loan_amnt int,	funded_amnt int,	funded_amnt_inv double,	term varchar(100), 	int_rate varchar(100),
	installment double, 	grade varchar(10), 	sub_grade varchar(10),	emp_title varchar(100),	emp_length varchar(100),
	home_ownership varchar(100),	annual_inc int,	verification_status varchar(100),	issue_Month varchar(30), issue_d DATE,	
    loan_status varchar(100),	pymnt_plan varchar(100),	descc varchar(4000),	purpose varchar(100),	title varchar(100),	
    zip_code varchar(100),	addr_state varchar(100),	dti double);
    
Describe finance_1;
    
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Finance_1.csv" 
INTO TABLE Finance_1 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM finance_1;

-- KPI 1
-- Year wise Loan Amount
SELECT 
	YEAR(issue_d) as YEAR, 
	round(SUM(loan_amnt)/1000000, 2) as Total_Loan_Amount_Million 
	FROM finance_1 GROUP BY YEAR(issue_d) ORDER BY YEAR(issue_d);

-- KPI 2
-- Grade and Sub-grade wise Revolving Balance
SELECT 
	grade,sub_grade,round(Sum(revol_bal)/1000000, 2) as Total_Revol_Bal_Million
	FROM finance_1 f1 JOIN finance_2 f2 ON f1.id = f2.id 
	GROUP BY  grade,sub_grade order by grade,sub_grade;

-- KPI 3
-- Total payment for verified status and Non verified Status
SELECT verification_status,
	Round(sum(total_pymnt)/ 1000000, 2) as Total_Payment_Million
	FROM finance_1 f1 JOIN finance_2 f2 ON f1.id = f2.id 
	Where Verification_status in('verified', 'Not Verified')
    And total_pymnt is not null
	GROUP BY verification_status;

-- KPI 4
-- State wise and month wise loan Status
SELECT
	addr_state,count(loan_status) as Total_Loans
	FROM finance_1 GROUP BY addr_state
	ORDER BY addr_state, total_loans;

SELECT
	addr_state,MONTHNAME(issue_d),COUNT(loan_status) FROM finance_1 
	Group by Addr_state, MONTHNAME(issue_d) Order by addr_state, MONTHNAME(issue_d);

-- KPI 4
-- State wise and month wise loan Status
SELECT addr_state,
    MONTH(issue_d) AS month_no,
    MONTHNAME(issue_d) AS issue_month,
    COUNT(loan_status) AS total_loans FROM Finance_1
	GROUP BY addr_state, MONTH(issue_d), MONTHNAME(issue_d)
	ORDER BY addr_state, month_no;

-- KPI 5
-- Home Ownership vs Last Payment Date
SELECT 
	year(last_pymnt_d) As Last_payment_year,
    home_ownership,Round(sum(Total_pymnt)/ 1000, 2) As Total_Payment_thousands
    FROM finance_1 f1 JOIN finance_2 f2 ON   f1.id = f2.id 
	GROUP BY year(last_pymnt_d),home_ownership 
    order by year(last_pymnt_d),home_ownership;




    
    
























