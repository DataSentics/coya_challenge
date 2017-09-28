# Coya Business Intelligence challenge - Flight delay insurance product recommendation.

# Specification
There is an idea in the backlog regarding a new insurance product for flight delays. Using the following dataset and the latest year available:

http://stat-computing.org/dataexpo/2009/the-data.html

# Our approach
To be efficient and come to a reasonable result in short time (one day) we used the tools where we are the most comfortable. The steps:
## ETL
We implemented the data preparation pipeline orchestration within the Keboola platform (cloud based ETL):
Python + SQL (running inside Keboola platform) for downloading data and data preparation
Snowflake (cloud analytical database) for storing prepared data
Tableau for visualisation of results
R for pricing predictive model

Proces

# Questions

## Question - 1) What can you conclude in terms of delay reasons and the time delays?
Please provide the visual analysis using a public view on Tablaeu, Qlik or similar.
If you use some code to prepare the data, please submit it also within the git bundle.

## Question 2) What can you recommend for exceptions in the coverage design?

