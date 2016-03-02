import pandas as pd
import numpy as np
import sqlalchemy
import simplejson

import matplotlib
import matplotlib.pyplot as plt

""""
This script aggreagtes the number taxi trips between neighbhoods for visulazation
via d3j chord diagram. 
"""

#Connect to the local Postgres database 
conn = sqlalchemy.create_engine('postgresql:///taxi' )

#querry to find the trips begining in the top 20 borros with the largest number of taxi pickups 
qr = """ 
		select  pickup_name, dropoff_name, sum(num_trips) as trips
		from daily_neighborhood_traffic
		where pickup_name in 
			(
				select pickup_name
				from daily_neighborhood_traffic
				group by pickup_name
				order by sum(num_trips) desc
				limit 20
			)
		and dropoff_name in 
			(
				select pickup_name
				from daily_neighborhood_traffic
				group by pickup_name
				order by sum(num_trips) desc
				limit 20
			)
		group by pickup_name, dropoff_name
	 """

df    = pd.io.sql.read_sql(qr,conn)

#Get an ordered array of all the unqiue neighbhord names and load into a dictionary for fast lookup
all_hoods = df.sort_values('trips')[::-1].dropoff_name.unique()

names = {}
for i, n in enumerate(all_hoods): names[n] = i

#The matrix will encode the number of trips between each neighborhood. Create & populate.
matrix = np.zeros((all_hoods.size, all_hoods.size))

df.apply( lambda x: matrix.__setitem__( (names[x.pickup_name], names[x.dropoff_name]), x.trips), axis=1);
matrix = matrix / sum(matrix)
file = open('./matrix.json','w'); file.write( simplejson.dumps( matrix.tolist() ))
file.close()


#generate a color for each neighbhood
color=map( matplotlib.colors.rgb2hex, plt.cm.rainbow(np.linspace(0,1, all_hoods.size)))


cmap = 'name,color\n'
for i, n in enumerate(all_hoods):

	cmap = cmap + '%s,%s\n' % (n.split('-')[0], color[i] ) 

file = open('./borro.csv','w'); 
file.write(cmap)
file.close()


