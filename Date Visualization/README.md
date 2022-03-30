# IBRD Data Analysis Dashboard.
Welcome to the __IBRD Data Analysis Project__.  

The second part of the IBRD Data Analysis Project is building a data analysis dashboard to highlight major insights and metrics.

Mission: provide BI solution with Tableau Dashboard in support of potential stakeholders to support their needs with KPI metrics and key points about World banking loans.

## Business Questions:
* What is the volume of loans and grants issued, as well as their ratio?
* Which countries were given these loans and what volume?
* How much funds are provided and how much of these funds are used?
* Are loans repaid on time?
* Which countries are issued loans more often?
* What interest were loans issued and what volume?
* I think we will be able to discover much more during the analysis!)

For comfortable interaction between stakeholders, the information is divided into 2 Dashboards: [Dashboard IBRD](https://public.tableau.com/app/profile/mykhailo2589/viz/DashboardIBRDStatementofLoansandIDAStatement/DashboardIBRD?publish=yes) and [Details Dashboard](https://public.tableau.com/app/profile/mykhailo2589/viz/DashboardIBRDStatementofLoansandIDAStatement/DashboardIBRD?publish=yes).

# 1. Dashboard IBRD
The main goal is to answer the questions of stakeholders about the work of the ___"International Bank for Reconstruction and Development"___ ([IBRD](https://en.wikipedia.org/wiki/International_Bank_for_Reconstruction_and_Development)) and, more precisely, about the loans provided to the world.

By default, all filters are reset and we see the situation in the world and its indicators for January 10, 2022

I suggest you to familiarize yourself with the main points of the work and visualization of this dashboard.

3 filters have been created for the user to get more detailed answers:
* __"YEAR(Board Approval Date)"__ - period selection
* __"Region"__ - selection of regions or region with countries
* __"Country"__ - select a list of countries or a specific country

Depending on the settings in the online mode, the data on the __2 Dashboards__ will change.

* __Original Principal Amount ($, M)__ - The original US dollar amount of the loan that is committed and approved. Measured in $. M - meaning a million. *Aggregate Sum*.
* __% Principal Amount__ - % of total of *"Original Principal Amount ($, M)"*
* __Country (count)__ - count of country
* __Approved Loan (count)__ - count of approved loan
* __Approved Loan (%)__  % of total of "count of approved loan'
* __MIN Interest Rate__ - min interest rate, "excluded 0" (P.S. For loans that could have more than one interest rate the interest rate is shown as “0”.)
* __AVG Interest Rate__ - average interest rate, "excluded 0" (P.S. For loans that could have more than one interest rate the interest rate is shown as “0”.)
* __MAX Interest Rate__ maximum interest rate
* __% of Total "Original Principal Amount__ - % of total of *"Original Principal Amount ($, M)"* 
* __Loan_Type__ - detailed description of each type in the folder *Project Definition*
* __Loan_Status__ -  detailed description of each status in the folder *Project Definition*

The __Reset button__ allows you to quickly cancel all filters.

# 2. Details Dashboard 

This Dashboard gives the user more detailed information in the context of each country.

This Dashboard is dependent on filtering on the first Dashboard IBRD.

* __Original Principal Amount ($, M)__ - The original US dollar amount of the loan that is committed and approved. Measured in $. M - meaning a million. *Aggregate Sum*.
* __MIN Interest Rate__ - Minimum interest rate, "excluded 0" (P.S. For loans that could have more than one interest rate the interest rate is shown as “0”.)
* __AVG Interest Rate__ - Average interest rate, "excluded 0" (P.S. For loans that could have more than one interest rate the interest rate is shown as “0”.)
* __MAX Interest Rate__ maximum interest rate
* __“Interest rate classification”__  - The conditional classification was created by me. The name of each group corresponds to its meaning
* __category share__ - % of total of *"Original Principal Amount ($, M)"* from "Pie chart"
* Chart __"More_Details"__ - Detailed description of columns in the folder *Project Definition*

# My findings and conclusions

__1.__ The peak volumes of loans granted are due to global economic crises and the Covid pandemic.

__2.__ The peak provision of loans in the context of countries occurs on global crises or local incidents in countries.

__3.__ The largest volumes of loans, as a rule, were provided to regions and countries, in particular, which are included in the TOP 30 countries with the largest population, with the exception of developed countries.

__4.__  84.58% of all loans granted fall on 3 out of 13 types of loans: 
* 49.79% on Fixed Spread Loans (FSL)
* 18.33% on Currency Pooled Loans (CPL)
* 16.46% Single Currency Loans (SCL)

__5.__ 70% of all issued loans have been paid by the current date, respectively 30% or $ 245 billion are in other statuses.

__6.__ According to the data provided, IBRD cooperates with 148 countries, but 189 countries are listed on the official website.

189-148=41 countries, so these 41 countries or other commercial organizations are combined in "__World__" definition in "__OTHER__" region.

__8.__ The highest interest rates fall on "World" and African countries.

__9.__ 54.82% of the total amount of loans issued with an __interest rate marked__ as “__0%__”, which in fact, according to the Definition of the dictionary, contains several interest rates and does not give us complete answers when analyzing the data. Therefore, this indicator was __excluded__ from the calculation of __Min, AVG Interest rate__.
