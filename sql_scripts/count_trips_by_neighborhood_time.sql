/*Number of daily/hourly trips between neighbhoods*/
select
		date(pickup_datetime) as day,
		extract( hour from pickup_datetime ) as hour,
		j1.ntaname as pickup_loc,
		j2.ntaname as dropoff_loc,
		count(*)  as num_trips 

into hourly_trips

from trips
	join nyc_geo_data j1 on ST_Within(pickup_loc::geometry, j1.geom) 
	join nyc_geo_data j2 on ST_Within(dropoff_loc::geometry, j2.geom)

group by  pickup_loc, dropoff_loc, day, hour, j1.ntaname. j2.ntaname;