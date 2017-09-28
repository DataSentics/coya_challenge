-- *NOTE*: We only import rows that were inserted/updated in last 28 days only from the `san_francisco_data` dataset
-- *ASSUMPTION*: The `san_francisco` dataset is being updated daily, i.e. every day, new data are generated and gathered in San Francisco.

-- I) Daily trend on "Damage Property" category
--- selecting the last "updated_datetime" for efficient incremental load in `Extraction: Chunk Load from data.sfgov.csv` script. 
CREATE OR REPLACE TABLE "last_updated_time_df" AS
SELECT 
	MAX(TRY_TO_TIMESTAMP_NTZ("updated_datetime")) as "last_updated_time"
FROM
	"san_francisco_data";

-- Calculating daily `Damaged Property` cases 
--- by requests (we only take requests created in last 5 days)
CREATE OR REPLACE TABLE "damaged_property_requests" AS
SELECT
    TO_DATE(TRY_TO_TIMESTAMP_NTZ("requested_datetime")) as "date",
    count(*) as "requests_count"
FROM
  "san_francisco_data"
WHERE
  "service_name" = 'Damaged Property' AND
  TO_DATE(TRY_TO_TIMESTAMP_NTZ("requested_datetime")) >= DATEADD('days',-5,CURRENT_DATE())
GROUP BY "date";

--- by closed cases
CREATE OR REPLACE TABLE "damaged_property_closed_cases" AS
SELECT
  TO_DATE(TRY_TO_TIMESTAMP("closed_date")) as "date",
  count(*) as "closed_cases_count"
FROM
  "san_francisco_data"
WHERE
  "service_name" = 'Damaged Property'
GROUP BY "date";

--- putting it together
CREATE OR REPLACE TABLE "damaged_property_evaluation" AS
SELECT
  IFNULL(dpr."date",dpc."date") as "date",
  IFNULL(dpr."requests_count",0) as "requests_count",
  IFNULL(dpc."closed_cases_count",0) as "closed_cases_count"
FROM
  "damaged_property_closed_cases" dpc
FULL OUTER JOIN
  "damaged_property_requests" dpr ON dpr."date" = dpc."date";
  
--- calculating percentage differences day-to-day
CREATE OR REPLACE TABLE "damaged_property_evaluation_growth" AS
SELECT
  t1."date",
  IFF(t2."requests_count" = 0 OR t2."requests_count" IS NULL, 0, (t1."requests_count" / t2."requests_count"-1)*100) as "requests_daily_percentage_growth",
  IFF(t2."closed_cases_count" = 0 OR t2."closed_cases_count", 0,  (t1."closed_cases_count" / t2."closed_cases_count"-1)*100) as "closed_cases_daily_percentage_growth"
FROM 
	"damaged_property_evaluation" t1 
LEFT JOIN 
	"damaged_property_evaluation" t2 ON t1."date" = DATEADD('days',1,t2."date");

--- adding the percentage difference to the original "damaged_property_evaluation" table. We take only last 3 days, 
--- so when the incremental update is performed (after this script finishes), it does not entirely overwrite the existing data
--- but only updates/add data 3 days back. 
CREATE OR REPLACE TABLE "damaged_property_evaluation" AS
SELECT
	dpo.*,
    dppg."requests_daily_percentage_growth",
    dppg."closed_cases_daily_percentage_growth"
FROM
	"damaged_property_evaluation" dpo 
LEFT JOIN
	"damaged_property_evaluation_growth" dppg ON dpo."date" = dppg."date"
WHERE dpo."date" > DATEADD('days',-3,CURRENT_DATE());
    
-- II) Category distribution
--- we create table that show us: how many requests and closed cases there was per category in last: 1 day (yesterday), 7 days and 28 days
CREATE OR REPLACE TABLE "request_frequency_per_service_category" AS
SELECT
    "service_name" as "service_name",
    SUM(IFF(TO_DATE(TRY_TO_TIMESTAMP_NTZ("requested_datetime")) = DATEADD('days',-1,CURRENT_DATE()),1,0)) as "requests_count_yesterday",
    SUM(IFF(TO_DATE(TRY_TO_TIMESTAMP_NTZ("requested_datetime")) >= DATEADD('days',-7,CURRENT_DATE()),1,0)) as "requests_count_last7days",
    SUM(IFF(TO_DATE(TRY_TO_TIMESTAMP_NTZ("requested_datetime")) >= DATEADD('days',-28,CURRENT_DATE()),1,0)) as "requests_count_last28days",
    SUM(IFF(TO_DATE(TRY_TO_TIMESTAMP_NTZ("closed_date")) = DATEADD('days',-1,CURRENT_DATE()),1,0)) as "closed_cases_count_yesterday",
    SUM(IFF(TO_DATE(TRY_TO_TIMESTAMP_NTZ("closed_date")) >= DATEADD('days',-7,CURRENT_DATE()),1,0)) as "closed_cases_count_last7days",
    SUM(IFF(TO_DATE(TRY_TO_TIMESTAMP_NTZ("closed_date")) >= DATEADD('days',-28,CURRENT_DATE()),1,0)) as "closed_cases_count_last28days"
FROM
  "san_francisco_data"
GROUP BY "service_name";
