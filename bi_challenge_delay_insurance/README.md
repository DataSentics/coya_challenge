# Coya Business Intelligence challenge - Flight delay insurance product recommendation.

# Specification
There is an idea in the backlog regarding a new insurance product for flight delays. Using the following dataset and the latest year available:

http://stat-computing.org/dataexpo/2009/the-data.html

1) What can you conclude in terms of delay reasons and the time delays?
2) What can you recommend for exceptions in the coverage design?

Please provide the visual analysis using a public view on Tablaeu, Qlik or similar.
If you use some code to prepare the data, please submit it also within the git bundle.

# Our approach - business
We were thinking about how to grasp the potential flight delay insurance product so that we have a good context for the data analysis. In terms of clients we focused a variant aimed at retail clients to protect them from complications arising from flight delays (products could also be built for airlines, airports, travel agencies, etc. but we didn't explore this further). For were working with the following model in our heads: if your flight is significantly delayed (for example at least 60min delay on arrival to destination) you will be paid a fixed compensation (e.g. 500 EUR). Other variations are of course possible (variable compensation depending on lenght of delay, etc.) but we sticked to this basic model for our thinking.

Generally after seeing that the average flight delay rate is very high (more than 40% of flights have delays) we figured we need to think about the product setup to avoid the situation when a client would have to pay 300 EUR premium for a potential 500 EUR compensation, which wouldn't make sense for anybody.

## Flight delay threshold
The first important parameter is the threshold (minimum number of minutes of delay) from which the coverage would start. We analyzed the ratio of delayed flights as a % of all flights depending on the threshold in minutes. 
![alt text](src/minutesToDelayPlot.png "Average delay rate vs. threshold in minutes")
It can be seen from this that more than 40% of flights have some delay and it wouldn't make sense to cover this (too frequent). From the graph we consider 45 minutes a optimum threshold ("knee" of the graph) - such delays are not that frequent (it is a rare random event) but still frequent enough that the coverage brings value to the customer. Also this is a threshold which makes business sense as well - when you need to catch a connecting flight or be somewhere on time for a meeting you typically have 30 minutes slack but 45 minutes is typically already a problem.

## What does delay depend on -> pricing and exclusions
We studied the delay data in more detail to get an idea how to price the product and what kind of exclusions to potentially introduce into the product. The underlying visual analyses can be found in 

## Exceptions




# Our approach - technical
To be efficient and come to a reasonable result in short time (one day) we used the tools where we are the most comfortable: 1) Python + SQL (running and orchestrated inside Keboola cloud ETL platform) for downloading data and data preparation
2) Snowflake (cloud analytical database) for storing prepared data and as a source for analytics
3) Tableau for visualisation of results (published to Tableau Public for sharing)
4) R for pilot pricing predictive model


