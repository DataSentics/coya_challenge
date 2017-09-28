"""
Following script extracts "flight delay" data from `http://stat-computing.org/dataexpo/2009/`
"""

import pandas as pd

# Defining "Flight delay data" url sources. 
url_list = ['http://stat-computing.org/dataexpo/2009/2007.csv.bz2',
            'http://stat-computing.org/dataexpo/2009/2008.csv.bz2']

# Loading the data from all the URLs
df_list = [pd.read_csv(url, compression='bz2') for url in url_list]

# Merging into one big DataFrame
df = pd.concat(df_list)

# Exporting the resulting DataFrame
df.to_csv('out/tables/output.csv', index=None, encoding='utf-8')
