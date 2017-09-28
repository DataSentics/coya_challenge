"""
Following script extracts `airport-code` data from `https://raw.githubusercontent.com/datasets/airport-codes/master/data/airport-codes.csv`
"""

import pandas as pd

# Connect to server and read the .csv with airport codes
df = pd.read_csv('https://raw.githubusercontent.com/datasets/airport-codes/master/data/airport-codes.csv')

# Parse coordinates 
coord = df['coordinates'].str.split(',', expand=True).astype(float)
coord.columns = ['longitude','latitude']
df['latitude'] = coord['latitude']
df['longitude'] = coord['longitude']
df.drop('coordinates', axis=1, inplace=True)

# Export the data
df.to_csv('out/tables/airport_codes.csv', index=None, encoding='utf-8')
