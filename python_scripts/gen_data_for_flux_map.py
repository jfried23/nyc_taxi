import pandas as pd
import numpy as np
import sqlalchemy
import simplejson

import matplotlib
import matplotlib.pyplot as plt

""""
This script finds the average number of people flowing into/out of each neighhood at a given time of day.
"""

#Connect to the local Postgres database 
conn = sqlalchemy.create_engine('postgresql:///taxi' )

#querry to find the total number of people traveling to a neighbhood per weekday / hour of the day\d
qr = """ 
select  pickup_name,
        dropoff_name,
		extract(hour from pickup_datetime) as hour,
        sum( passengers ) as flux

from neighborhood_trip_data

where extract(dow from pickup_datetime) not in (0,6) 
      or extract(dow from pickup_datetime) = 5 and extract(hour from pickup_datetime) < 18

group by  extract(hour from pickup_datetime), pickup_name, dropoff_name;

	 """

df    = pd.io.sql.read_sql(qr,conn)


#number of peopele leaving per place/ per hour
efflux = df.groupby(['pickup_name','hour']).agg({'flux':sum}).rename(columns={'flux':'efflux'})

#number of peopele entering per place/ per hour
influx = df.groupby(['dropoff_name','hour']).agg({'flux':sum}).rename(columns={'flux':'influx'})


mrg = pd.merge( efflux.reset_index(), influx.reset_index(), how='inner', left_on=['pickup_name','hour'], right_on=['dropoff_name','hour'] )

mrg = mrg[['pickup_name','hour','efflux','influx']]

mrg['net_flux'] = mrg.influx - mrg.efflux 


#Now reorient the data for d3j visulaization

json_data = pd.pivot_table( mrg, values='net_flux', index='pickup_name', columns='hour' ).fillna(0).to_json()