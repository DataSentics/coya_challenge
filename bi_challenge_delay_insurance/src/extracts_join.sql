-- Following script joins the resulting tables from *.py extractor into one
CREATE OR REPLACE TABLE "enhanced_flight_delay_table" AS
SELECT
  "Year", 
  "Month",
  "DayofMonth", 
  "DayOfWeek", 
  "DepTime", 
  "CRSDepTime", 
  "ArrTime", 
  "CRSArrTime", 
  "UniqueCarrier", 
  "FlightNum", 
  "TailNum", 
  "ActualElapsedTime", 
  "CRSElapsedTime", 
  "AirTime", 
  "ArrDelay", 
  "DepDelay", 
  "Origin", 
  "Dest", 
  "Distance",
  "TaxiIn", 
  "TaxiOut", 
  "Cancelled", 
  "CancellationCode", 
  "Diverted", 
  "CarrierDelay", 
  "WeatherDelay", 
  "NASDelay", 
  "SecurityDelay", 
  "LateAircraftDelay",
  ao."type" as "OriginAirportType",
  ao."longitude" as "OriginLongitude",
  ao."latitude" as "OriginLatitude",
  ao."name" as "OriginAirportName",
  ad."type" as "DestAirportType",
  ad."name" as "DestAirportName",
  ad."longitude" as "DestLongitude",
  ad."latitude" as "DestLatitude",
  ac."name" as "airlineName"
FROM 
	"flight_delays" f
LEFT JOIN
	"airport_codes" ao ON f."Origin" = ao."iata_code" AND ao."type" != 'closed'
LEFT JOIN
	"airport_codes" ad ON f."Dest" = ad."iata_code" AND ad."type" != 'closed'
LEFT JOIN 
	"airlines_codes" ac ON f."UniqueCarrier" = ac."carrier_code";
