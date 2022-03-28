# IBRD Data Analysis Dashboard.
Welcome to the __IBRD Data Analysis Project__.  

The second part of the IBRD Data Analysis Project is the creation of the Dashboard. 

Which mission is to provide the stakeholders with the opportunity to find quick answers to questions, in an interactive mode.
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
Its main goal is to answer the questions of stakeholders about the work of the ___"International Bank for Reconstruction and Development"___ ([IBRD](https://en.wikipedia.org/wiki/International_Bank_for_Reconstruction_and_Development)) and, more precisely, about the loans provided to the world.

By default, all filters are reset and we see the situation in the world and its indicators for January 10, 2022

I suggest you to familiarize yourself with the main points of the work and visualization of this dashboard.

3 filters have been created for the user to get more detailed answers:
* __"YEAR(Board Approval Date)"__ - period selection
* __"Region"__ - selection of regions or region with countries
* __"Country"__ - select a list of countries or a specific country

Depending on the settings in the online mode, the data on the __2 Dashboards__ will change.

In the upper left corner, the table gives answers to questions related to the region and KPI metrics .

In the upper right corner of the visualization of the world map with countries and % receipt of the volume of credit lines from the selected list.

In the lower left corner is a visualization of a line graph, which shows the relations and correlation between amount of loans and time.

In the lower right corner, information is provided on the __Loan_Type__ and __Loan_Status__, depending on the selected criteria.

The __Reset button__ allows you to quickly cancel all filters.

# 2. Details Dashboard 

This Dashboard gives the user more detailed information in the context of each country.

This Dashboard is dependent on filtering on the first Dashboard IBRD.

In addition, for convenience, an __“Interest rate classification”__ was created and a __filter__, respectively.

In the upper left corner, the main KPIs for countries.

In the upper right corner is the “Interest rate classification” pie chart, which displays the number of loans issued depending on the classifier.

The lower half of the Dashboard displays a table with the details of each issued loan.

# My findings and conclusions

1)  The peak volumes of loans granted are due to global economic crises and the Covid pandemic
2)  The peak provision of loans in the context of countries occurs on global crises or local incidents in countries
3) The largest volumes of loans, as a rule, were provided to regions and countries, in particular, which are included in the TOP 30 countries with the largest population, with the exception of developed countries
4)  84.58% of all loans granted fall on 3 out of 13 types of loans: 
* 49.79% on Fixed Spread Loans (FSL)
* 18.33% on Currency Pooled Loans (CPL)
* 16.46% Single Currency Loans (SCL)
5) 70% of all issued loans have been paid by the current date, respectively 30% or $ 245 billion are in other statuses
6) According to the data provided, IBRD cooperates with 148 countries, but 189 countries are listed on the official website. Part of the issued loans is listed instead of the country "World". Perhaps these 41 countries or other commercial organizations are combined in this word
7) The highest interest rates fall on "World" and African countries.
8) 54.82% of the total amount of loans issued with an __interest rate marked__ as “__0%__”, which in fact, according to the Definition of the dictionary, contains several interest rates and does not give us complete answers when analyzing the data. Therefore, this indicator was __excluded__ from the calculation of __Min, AVG Interest rate__.
