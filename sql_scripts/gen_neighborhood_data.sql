/*Map each trip to a pickup/dropoff neighbhood*/
select  vendorID,
		pickup_datetime,
		dropoff_datetime,
		passengers,
		distance,
		RateCodeID,
		payment_type,
		fare_amount,
		extra,
		mta_tax,
		tip_amount,
		tolls_amount,
		improvement_surcharge, 
		total_amount,
		cab_color,
		pickup_loc,
		dropoff_loc,
		j1.ntaname as pickup_name,
		j2.ntaname as dropoff_name

into trip_data
from trips
	join nyc_geo_data j1 on ST_Within(pickup_loc::geometry, j1.geom) 
	join nyc_geo_data j2 on ST_Within(dropoff_loc::geometry, j2.geom);
