"""
This script connects to `data.sfgov` server and downloads the data (in chunks - chunks are then put together to form the complete table).
To avoid repetitive downloading of already downloaded chunks, only the newly updated data are downloaded from the `data.sfgov` server. 
This is achieved through `last_updated_time_df.csv`, which stores the most recent update the dataset had. This way, we can get (almost)
arbitrarily close to real-time data processing. 
"""

from sodapy import Socrata
import csv
import pandas as pd

# First, look what was the max(`updated_datetime`) when we extracted the dataset last time.
# We will look only at the data that were generated from the mentioned timestamp onwards. 
try:
  last_updated_time_df = pd.read_csv('in/tables/last_updated_time_df.csv')
  last_updated_time = pd.to_datetime(last_updated_time_df['last_updated_time'].values[0]).strftime('%Y-%m-%dT%H:%M:%S')
except FileNotFoundError:
  last_updated_time = None

# Definitions incremental/chunk load 
## fieldnames (columns)
fieldnames = ['service_name',
             'long',
             'police_district',
             'status_notes',
             'service_subtype',
             'neighborhoods_sffind_boundaries',
             'source',
             'requested_datetime',
             'service_request_id',
             'supervisor_district',
             'address',
             'service_details',
             'agency_responsible',
             'lat',
             'status_description',
             'closed_date',
             'updated_datetime',
             'media_url',
             'point']


## variables for incremental load 
offset = 0
chunk_size = 8e5
load_again = True

# Open temporary csv file and write chunk by chunk
with open('out/tables/sfdata.csv', 'w') as csv_file:
    while load_again:
        # (Re)establish connection with sfgov API
        client = Socrata("data.sfgov.org", None)
        # Receive chunk of data
        # 1) either we already have some starting point in `updated_datetime`
        if last_updated_time:
          	results = client.get("ktji-gk7t", 
                                 limit=int(chunk_size), 
                                 where="updated_datetime >= '{}'".format(last_updated_time),
                                 order='service_request_id',
                                 offset=int(offset))
        # 2) or there is no starting point and we extract the entire dataset
        else:
          	results = client.get("ktji-gk7t", 
                                 limit=int(chunk_size), 
                                 order='service_request_id', 
                                 offset=int(offset))
        # Write the chunk rows into the csv file
        writer = csv.DictWriter(csv_file,fieldnames=fieldnames)
        writer.writeheader()
        for result_item in results:
            try:
                writer.writerow(result_item)
            except UnicodeEncodeError:
                print('Encode Error') 
        # Check whether there is more data API can provide us with
        if len(results) == chunk_size:
            offset += chunk_size
        else:
            load_again = False
