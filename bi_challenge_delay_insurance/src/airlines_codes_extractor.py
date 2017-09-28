"""
Following script extracts data about airlines (primarily names and unique carrier codes) from 
https://raw.githubusercontent.com/jpatokal/openflights/master/data/airlines.dat
"""
import pandas as pd

# Connect to server and read .dat file with airlines codes/names as csv
df = pd.read_csv('https://raw.githubusercontent.com/jpatokal/openflights/master/data/airlines.dat')
df.columns = ['id','name','aux1','carrier_code','extended_code','name_abbr','country','aux2']

# Export 
df.to_csv('out/tables/airline_codes.csv', index=None, encoding='utf-8')
