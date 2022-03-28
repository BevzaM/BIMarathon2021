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


