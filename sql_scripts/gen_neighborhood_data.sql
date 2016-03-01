/*Map each trip to a pickup/dropoff neighborhood*/
select  pickup_datetime,
		dropoff_datetime,
		passengers,
		distance,
		payment_type,
		fare_amount,
		tip_amount,
		cab_color,
		pickup_loc,
		dropoff_loc,
		j1.ntaname  as pickup_name,
		j1.borocode as pickup_boro,
		j2.ntaname as dropoff_name,
		j2.borocode as dropoff_boro

into neighborhood_trip_data

from trips
	join nyc_geo_data j1 on ST_Within(pickup_loc::geometry, j1.geom) 
	join nyc_geo_data j2 on ST_Within(dropoff_loc::geometry, j2.geom);



/*Now create a table tracking the number of trips between each neighbhood 
by the day of the week and hour of the day */
select  extract(dow from pickup_datetime) as day,
        extract(hour from pickup_datetime) as hour,
        pickup_name,
        dropoff_name,
        count(*) as num_trips

into daily_neighborhood_traffic 

from neighborhood_trip_data
group by day, hour, pickup_name, dropoff_name;


