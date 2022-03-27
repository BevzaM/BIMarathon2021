-- create database BI_Marathon_IBRD

  create database BI_Marathon_IBRD;
  Use BI_Marathon_IBRD;

-- Creating a temp table to loud our CSV file

create table IBRD_table_temp
(
Region varchar(36)
,Country varchar(36)
,Country_Code varchar(3)
,Borrower varchar(72)
,Guarantor varchar(72)
,Guarantor_Country_Code varchar(3)
,Loan_Number varchar(36)
,Loan_Type varchar(36)
,Loan_Status varchar(36)
,Project_Name varchar(72)
,Project_ID varchar(36)
,Original_Principal_Amount decimal (20,2)
,Undisbursed_Amount decimal (20,2)
,Disbursed_Amount decimal (20,2)
,Cancelled_Amount decimal (20,2)
,Repaid_to_IBRD decimal (20,2)
,Due_to_IBRD decimal (20,2)
,Exchange_Adjustment decimal (20,2)
,Borrowers_Obligation decimal (20,2)
,Sold_3rd_Party decimal (20,2)
,Repaid_3rd_Party decimal (20,2)
,Loans_Held decimal (20,2)
,Interest_Rate decimal (6,4)
,First_Repayment_Date varchar(36)
,Last_Repayment_Date varchar(36)
,Agreement_Signing_Date varchar(36)
,Board_Approval_Date varchar(36)
,Effective_Date varchar(36)
,Close_Date varchar(36)
,Last_Disbursement_Date varchar(36)
);

 -- check table from Null values
 
  Select *
From ibrd_table_temp
Where 
Region is null or
Country is null or
Country_Code is null or
Borrower is null or
Guarantor is null or
Guarantor_Country_Code is null or
Loan_Number is null or
Loan_Type is null or
Loan_Status is null or
Project_Name is null or
Project_ID is null or
Original_Principal_Amount is null or
Undisbursed_Amount is null or
Disbursed_Amount is null or
Cancelled_Amount  is null or
Repaid_to_IBRD is null or
Due_to_IBRD is null or
Exchange_Adjustment is null or
Borrowers_Obligation is null or
Sold_3rd_Party is null or
Repaid_3rd_Party is null or
Loans_Held is null or
Interest_Rate is null or
First_Repayment_Date is null or
Last_Repayment_Date is null or
Agreement_Signing_Date is null or
Board_Approval_Date is null or
Effective_Date is null or
Close_Date is null or
Last_Disbursement_Date is null;

-- ONLY Use this script If you need remove the values in your table
truncate ibrd_table_temp;

-- select all rows from tem_table
select * 
from ibrd_table_temp;

-- create #1 dimention "Dim_Location"

create table Dim_Location (
	Location_ID int not null auto_increment
    ,Region varchar(36)
    ,Country varchar(36)
    ,Country_Code varchar (3)
    ,primary key (Location_ID)
    );

-- create #2 dimention "Dim_Loan"

create table Dim_Loan
(
	 Loan_Number varchar(36) not null
    ,Loan_Type varchar(36)
    ,Loan_Status varchar(36)
    ,Project_Name varchar(72)
    ,Project_ID varchar(36)
	,Borrower varchar(72)
    ,Guarantor varchar(72)
    ,Guarantor_Country_Code varchar(3)
    ,primary key (Loan_Number)
    );
    
-- create #3 "Record_of_loans" table

create table Record_of_loans
(
	Record_ID int not null auto_increment
    ,Location_ID int
    ,Loan_Number varchar(36)
    ,Original_Principal_Amount decimal (20,2)
    ,Undisbursed_Amount decimal (20,2)
    ,Disbursed_Amount decimal (20,2)
    ,Cancelled_Amount decimal (20,2)
    ,Repaid_to_IBRD decimal (20,2)
    ,Due_to_IBRD decimal (20,2)
    ,Exchange_Adjustment decimal (20,2)
    ,Borrowers_Obligation decimal (20,2)
    ,Sold_3rd_Party decimal (20,2)
    ,Repaid_3rd_Party decimal (20,2)
    ,Loans_Held decimal (20,2)
    ,Interest_Rate decimal (6,4)
    ,First_Repayment_Date varchar(36)
    ,Last_Repayment_Date varchar(36)
    ,Agreement_Signing_Date varchar(36)
    ,Board_Approval_Date varchar(36)
    ,Effective_Date varchar(36)
    ,Close_Date varchar(36)
    ,Last_Disbursement_Date varchar(36)
    , primary key (Record_ID)
    , FOREIGN KEY (Location_ID) REFERENCES dim_location (Location_ID) ON DELETE SET NULL
    , FOREIGN KEY (Loan_Number) REFERENCES Dim_Loan (Loan_Number) ON DELETE SET NULL
    );
    
-- uploading #1 "dim_loan" table
INSERT IGNORE INTO dim_loan (Loan_Number, Loan_Type, Loan_Status, Project_Name, Project_ID, Borrower, Guarantor, Guarantor_Country_Code)
SELECT DISTINCT Loan_Number, Loan_Type, Loan_Status, Project_Name, Project_ID, Borrower, Guarantor, Guarantor_Country_Code FROM ibrd_table_temp;

-- check result
select *
from dim_loan;

-- uploading #2 "dim_location" table
INSERT IGNORE INTO dim_location (Region, Country, Country_Code)
SELECT DISTINCT Region, Country, Country_Code 
FROM ibrd_table_temp;

-- check result
select *
from dim_location;

-- uploading #4  "record_of_loans" table
INSERT IGNORE INTO record_of_loans (
      Location_ID, Loan_Number
    , Original_Principal_Amount, Undisbursed_Amount, Disbursed_Amount, Cancelled_Amount, Repaid_to_IBRD, Due_to_IBRD
    , Exchange_Adjustment, Borrowers_Obligation, Sold_3rd_Party, Repaid_3rd_Party, Loans_Held, Interest_Rate
    , First_Repayment_Date, Last_Repayment_Date, Agreement_Signing_Date, Board_Approval_Date
    , Effective_Date, Close_Date, Last_Disbursement_Date)
SELECT distinct
      dim_location.Location_ID
    , dim_loan.Loan_Number
    , tmp.Original_Principal_Amount
    , tmp.Undisbursed_Amount
    , tmp.Disbursed_Amount
    , tmp.Cancelled_Amount
    , tmp.Repaid_to_IBRD
    , tmp.Due_to_IBRD
    , tmp.Exchange_Adjustment
    , tmp.Borrowers_Obligation
    , tmp.Sold_3rd_Party
    , tmp.Repaid_3rd_Party
    , tmp.Loans_Held
    , tmp.Interest_Rate
    , tmp.First_Repayment_Date
    , tmp.Last_Repayment_Date
    , tmp.Agreement_Signing_Date
    , tmp.Board_Approval_Date
    , tmp.Effective_Date
    , tmp.Close_Date
    , tmp.Last_Disbursement_Date
FROM ibrd_table_temp AS tmp
JOIN dim_loan ON dim_loan.Loan_Number = tmp.Loan_Number
JOIN dim_location ON dim_location.Country_Code = tmp.Country_Code;

-- Check from duplicate Rows using Group By and Having clause in dim
-- # record_of_loans

SELECT 
     Loan_Number
    ,Original_Principal_Amount
    ,Undisbursed_Amount
    ,Disbursed_Amount
    ,Cancelled_Amount
    ,Repaid_to_IBRD
    ,Due_to_IBRD
    ,Exchange_Adjustment
    ,Borrowers_Obligation
    ,Sold_3rd_Party
    ,Repaid_3rd_Party
    ,Loans_Held
    ,Interest_Rate
    ,First_Repayment_Date
    ,Last_Repayment_Date
    ,Agreement_Signing_Date
    ,Board_Approval_Date
    ,Effective_Date
    ,Close_Date
    ,Last_Disbursement_Date
    , count(*) as CNT
FROM record_of_loans
group by 
  Loan_Number
    ,Original_Principal_Amount
    ,Undisbursed_Amount
    ,Disbursed_Amount
    ,Cancelled_Amount
    ,Repaid_to_IBRD
    ,Due_to_IBRD
    ,Exchange_Adjustment
    ,Borrowers_Obligation
    ,Sold_3rd_Party
    ,Repaid_3rd_Party
    ,Loans_Held
    ,Interest_Rate
    ,First_Repayment_Date
    ,Last_Repayment_Date
    ,Agreement_Signing_Date
    ,Board_Approval_Date
    ,Effective_Date
    ,Close_Date
    ,Last_Disbursement_Date
Having Count(*) > 1;

-- # dim_loan
SELECT 
  Loan_Number
, Loan_Type
, Loan_Status
, Project_Name
, Project_ID
, Borrower
, Guarantor
, Guarantor_Country_Code
    , count(*) as CNT
FROM dim_loan
group by 
 Loan_Number
, Loan_Type
, Loan_Status
, Project_Name
, Project_ID
, Borrower
, Guarantor
, Guarantor_Country_Code
Having Count(*) > 1;

-- # dim_location
SELECT 
  Region
, Country
, Country_Code
    , count(*) as CNT
FROM dim_location
group by
 Region
, Country
, Country_Code
Having Count(*) > 1;


-- test # 1!! ADD duplicate Rows
INSERT INTO dim_location (Region, Country , Country_Code)
VALUES ('AFRICA EAST' ,'Angola', 'AO');
INSERT INTO dim_location (Region, Country , Country_Code)
VALUES ('AFRICA EAST' ,'Kenya', 'KE');

-- test # 1.1 !!! Check from duplicate Rows using Group By and Having clause
SELECT distinct
Location_ID
,Region
, Country
, Country_Code
    , count(*) as CNT
FROM dim_location
group by 
Region
, Country
, Country_Code
Having CNT > 1;

-- Check #1.2 I am using the SQL MIN function to calculate the minimum Location_ID of each row of data and then excluding it to leave only duplicates
  SELECT *
    FROM dim_location
    WHERE Location_ID NOT IN
    (
        SELECT MIN(Location_ID)
        FROM dim_location
        GROUP BY Region
, Country
, Country_Code
    )
    Order by Country; 


-- Check from duplicate Rows using Common Table Expressions (CTE)

With CTE (Location_ID, Region , Country, Country_Code, duplicatecount)
    AS (select Location_ID, Region , Country, Country_Code,
    ROW_NUMBER() OVER(partition BY Region , Country, Country_Code 
    ORDER By Location_ID) AS duplicatecount
    From dim_location)
select *
 FROM CTE
 WHERE duplicatecount > 1;  
 
-- Option : Remove Duplicate Rows Using ROW_NUMBER()

    DELETE FROM dim_location
    WHERE Location_ID 
    IN(  
    SELECT Location_ID 
    FROM 
    (SELECT Location_ID,  ROW_NUMBER()   
       OVER (PARTITION BY Region , Country, Country_Code ORDER BY Location_ID) AS row_num   
    FROM dim_location) AS temp_table 
    WHERE row_num>1  
);  

-- Use distinct keyword to see unic Region
select distinct Region
From dim_location;

-- Using the "Case when" function to create a new column to understand the number of countries in the "Continents" list.
SELECT Count(*) as number_of_countries,
Case 
When Region in ('AFRICA EAST', 'AFRICA WEST', 'MIDDLE EAST AND NORTH AFRICA') Then 'Africa'
When Region in ('EAST ASIA AND PACIFIC', 'EUROPE AND CENTRAL ASIA', 'SOUTH ASIA','OTHER') Then 'Eurasia'
When Region = 'LATIN AMERICA AND CARIBBEAN' Then 'AMEC'
End As 'continents'
From dim_location
Group By Continents;

-- test #3  Using the COALESCE function if we have  Null at column 
INSERT INTO dim_location (Region, Country , Country_Code)
VALUES ('AFRICA EAST' ,null, 'AO');
INSERT INTO dim_location (Region, Country , Country_Code)
VALUES ('AFRICA EAST' ,null, null);

-- Check table 
select *
From dim_location
Where Region is null or
Country is null or
Country_Code is null;

-- change null from 'N/A'
Select Location_ID, COALESCE(Region, 'N/A') , COALESCE(Country, 'N/A'), COALESCE(Country_Code, 'N/A')
From dim_location;

-- change null from 'N/A'
update dim_location
SET Country = COALESCE(Country, 'N/A'),
 Region = COALESCE(Region, 'N/A'), 
 Country_Code = COALESCE(Country_Code, 'N/A');

-- Check 'N/A'
Select *
from dim_location
    Where 
    Country = 'N/A' or 
    Region = 'N/A' or
Country_Code = 'N/A';

 -- delete    
Delete from dim_location
Where
    Country = 'N/A' or 
    Region = 'N/A' or
Country_Code = 'N/A';

-- test NULLIF : INSERT test row data
INSERT INTO dim_location (Region, Country , Country_Code)
VALUES ('AFRICA EAST' ,'N/A', 'AO');
INSERT INTO dim_location (Region, Country , Country_Code)
VALUES ('AFRICA EAST' ,'N/A', 'N/A');

-- check table
select *
From dim_location
Where Region = 'N/A' or
Country  = 'N/A' or
Country_Code  = 'N/A';

-- change 'N/A' to NULL
update dim_location
SET Country = NULLIF(Country, 'N/A'),
 Region = NULLIF(Region, 'N/A'), 
 Country_Code = NULLIF(Country_Code, 'N/A')
Where Region = 'N/A' or
Country  = 'N/A' or
Country_Code  = 'N/A';

-- check NULL
select *
From dim_location
Where Region is null or
Country is null or
Country_Code is null;

Delete From dim_location
Where Region is null or
Country is null or
Country_Code is null;

-- Examples of MySQL GREATEST() and LEAST() if need change same values
Select Record_ID, Loan_Number, GREATEST(Original_Principal_Amount, Undisbursed_Amount, Disbursed_Amount) as max_value,
 LEAST(Original_Principal_Amount, Undisbursed_Amount, Disbursed_Amount)  as min_value
 From record_of_loans;
 --  Changes value if less to greater
 Select Record_ID, Loan_Number, GREATEST(5000000, Original_Principal_Amount) as New_value
 From record_of_loans
 Order By New_value asc;
 -- Changes the value if greater than the specified value to a smaller one
  Select LEAST(999000000, Original_Principal_Amount) as New_value
 From record_of_loans
 Order BY New_value desc;
 
-- USE Common Table Expressions (CTEs) to find data according to the business task

 With FIX_Location AS (
 SELECT Distinct Location_ID
 FROM dim_location
 WHERE Country IN ("Brazil", "Mexico")), 
 AVG_Amount_date AS (
 SELECT AVG(Original_Principal_Amount) AS AVG_Amount
 FROM record_of_loans
 WHERE date_format(str_to_date(Board_Approval_Date, '%c/%e/%Y'), '%Y') between '2020' and '2022')
 SELECT Location_ID, Original_Principal_Amount, Board_Approval_Date
 FROM record_of_loans
 WHERE Location_ID IN (SELECT Distinct Location_ID from FIX_Location)
 AND Original_Principal_Amount >= (SELECT Original_Principal_Amount from AVG_Amount_date) AND
 (date_format(str_to_date(Board_Approval_Date, '%c/%e/%Y'), '%Y') between '2020' and '2022')
 ORDER BY Original_Principal_Amount desc;
 
 -- use this script if you need to find responses within a certain period of time and group the values
SELECT Location_ID, 
SUM(CASE WHEN date_format(str_to_date(Board_Approval_Date, '%c/%e/%Y'), '%c/%Y') = '1/2021' THEN Original_Principal_Amount END) AS "JAN-2021",
SUM(CASE WHEN date_format(str_to_date(Board_Approval_Date, '%c/%e/%Y'), '%c/%Y') = '2/2021' THEN Original_Principal_Amount END) AS "FEB-2021",
SUM(CASE WHEN date_format(str_to_date(Board_Approval_Date, '%c/%e/%Y'), '%c/%Y') = '3/2021' THEN Original_Principal_Amount END) AS "MAR-2021"
FROM record_of_loans
WHERE date_format(str_to_date(Board_Approval_Date, '%c/%e/%Y'), '%c/%Y') BETWEEN  '01/2021' and '12/2021'
Group BY 1;

-- At this point, I suggest changing the data type for dates from varchar to date into a standard format for MySQL
-- (if you want to use a script where the dates are still in varchar (text) format, update/load from ... like I did at the beginning)
-- Pivoting Data w/ CASE WHEN
update record_of_loans 
set First_Repayment_Date = nullif(DATE_FORMAT(STR_TO_DATE(First_Repayment_Date, '%c/%e/%Y'),'%Y-%c-%e'), '0000-0-0')
, Last_Repayment_Date = nullif(DATE_FORMAT(STR_TO_DATE(Last_Repayment_Date, '%c/%e/%Y'),'%Y-%c-%e'), '0000-0-0')
, Agreement_Signing_Date = nullif(DATE_FORMAT(STR_TO_DATE(Agreement_Signing_Date, '%c/%e/%Y'),'%Y-%c-%e'), '0000-0-0') 
, Board_Approval_Date = nullif(DATE_FORMAT(STR_TO_DATE(Board_Approval_Date, '%c/%e/%Y'),'%Y-%c-%e'), '0000-0-0')
, Effective_Date = nullif(DATE_FORMAT(STR_TO_DATE(Effective_Date, '%c/%e/%Y'),'%Y-%c-%e'), '0000-0-0')
, Close_Date = nullif(DATE_FORMAT(STR_TO_DATE(Close_Date, '%c/%e/%Y'),'%Y-%c-%e'), '0000-0-0') 
, Last_Disbursement_Date = nullif(DATE_FORMAT(STR_TO_DATE(Last_Disbursement_Date, '%c/%e/%Y'),'%Y-%c-%e'), '0000-0-0');

-- Check 'record_of_loans' date values
SELECT First_Repayment_Date, Last_Repayment_Date, Agreement_Signing_Date, Board_Approval_Date, Effective_Date, Close_Date, Last_Disbursement_Date
FROM bi_marathon_ibrd.record_of_loans;

ALTER TABLE `bi_marathon_ibrd`.`record_of_loans` 
CHANGE COLUMN `First_Repayment_Date` `First_Repayment_Date` DATE NULL DEFAULT NULL,
CHANGE COLUMN `Last_Repayment_Date` `Last_Repayment_Date` DATE NULL DEFAULT NULL, 
CHANGE COLUMN `Agreement_Signing_Date` `Agreement_Signing_Date` DATE NULL DEFAULT NULL, 
CHANGE COLUMN `Board_Approval_Date` `Board_Approval_Date` DATE NULL DEFAULT NULL, 
CHANGE COLUMN `Effective_Date` `Effective_Date` DATE NULL DEFAULT NULL, 
CHANGE COLUMN `Close_Date` `Close_Date` DATE NULL DEFAULT NULL, 
CHANGE COLUMN `Last_Disbursement_Date` `Last_Disbursement_Date` DATE NULL DEFAULT NULL;

-- Recursive CTEs
-- Self JOINS
-- Window Functions
SELECT name
, GPA
, row_number() OVER (ORDER BY GPA DESC)
, RANK () OVER (ORDER BY GPA DESC)
, DENSE_RANK() (ORDER BY GPA DESC);

-- Calculating Running Totals
Select month, Revenue, SUM(Revenue) OVER (ORDER BY MONTH) AS Comulative
From monthly_REVENUE

-- Delta Values


