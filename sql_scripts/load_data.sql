/* table for reading in raw yellow data file*/
create table yellow_trips(
	vendorID integer,
	pickup_datetime timestamp,
	dropoff_datetime timestamp,
	passengers integer,
	distance numeric,
	pickup_longitude numeric,
	pickup_latitude numeric,
	RateCodeID integer,
	store_and_fwd_flag char(1),
	dropoff_longitude numeric,
	dropoff_latitude numeric,
	payment_type integer,
	fare_amount numeric,
	extra numeric,
	mta_tax numeric,
	tip_amount numeric,
	tolls_amount numeric,
	improvement_surcharge numeric, 
	total_amount numeric
);

create table green_trips(
	vendorID integer,
	pickup_datetime timestamp,
	dropoff_datetime timestamp,
	store_and_fwd_flag char(1),
	RateCodeID integer,
	pickup_longitude numeric,
	pickup_latitude numeric,
	dropoff_longitude numeric,
	dropoff_latitude numeric,
	passengers integer,
	distance numeric,
	fare_amount numeric,
	extra numeric,	
	mta_tax numeric,
	tip_amount numeric,
	tolls_amount numeric,
	ehail_fee numeric,
	improvement_surcharge numeric, 
	total_amount numeric,
	payment_type integer,
	trip_type integer,
    junk varchar(3),
    junk2 varchar(3)
);

copy yellow_trips from '/Users/friedj12/Documents/Data/NYC/data/yellow_tripdata_2015-01.csv' delimiter ',' csv header;
copy yellow_trips from '/Users/friedj12/Documents/Data/NYC/data/yellow_tripdata_2015-02.csv' delimiter ',' csv header;
copy yellow_trips from '/Users/friedj12/Documents/Data/NYC/data/yellow_tripdata_2015-03.csv' delimiter ',' csv header;
copy yellow_trips from '/Users/friedj12/Documents/Data/NYC/data/yellow_tripdata_2015-04.csv' delimiter ',' csv header;
copy yellow_trips from '/Users/friedj12/Documents/Data/NYC/data/yellow_tripdata_2015-05.csv' delimiter ',' csv header;
copy yellow_trips from '/Users/friedj12/Documents/Data/NYC/data/yellow_tripdata_2015-06.csv' delimiter ',' csv header;

copy green_trips from '/Users/friedj12/Documents/Data/NYC/data/green_tripdata_2015-01.csv' delimiter ',' csv header;
copy green_trips from '/Users/friedj12/Documents/Data/NYC/data/green_tripdata_2015-02.csv' delimiter ',' csv header;
copy green_trips from '/Users/friedj12/Documents/Data/NYC/data/green_tripdata_2015-03.csv' delimiter ',' csv header;
copy green_trips from '/Users/friedj12/Documents/Data/NYC/data/green_tripdata_2015-04.csv' delimiter ',' csv header;
copy green_trips from '/Users/friedj12/Documents/Data/NYC/data/green_tripdata_2015-05.csv' delimiter ',' csv header;
copy green_trips from '/Users/friedj12/Documents/Data/NYC/data/green_tripdata_2015-06.csv' delimiter ',' csv header;


/*Persistant table aggregating all the trip data*/
create table trips(
	vendorID integer,
	pickup_datetime timestamp,
	dropoff_datetime timestamp,
	passengers integer,
	distance numeric,
	RateCodeID integer,
	payment_type integer,
	fare_amount numeric,
	extra numeric,
	mta_tax numeric,
	tip_amount numeric,
	tolls_amount numeric,
	improvement_surcharge numeric, 
	total_amount numeric,
	cab_color char(1) default 'U',
	pickup_loc geography(POINT,4326) default null,
	dropoff_loc geography(POINT,4326) default null
);

/*insert data from yellow cabs */
insert into trips( 
		   vendorID, 
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
	       dropoff_loc
	       )	
 	 select vendorID, 
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
	       tolls_amount,
	       'y',
	       ST_SetSRID( ST_MakePoint( pickup_longitude, pickup_latitude), 4326) as pickup_loc,
	       ST_SetSRID( ST_MakePoint( dropoff_longitude, dropoff_latitude), 4326) as dropoff_loc
	from yellow_trips
	where (pickup_longitude != 0 and pickup_latitude != 0) or 
	      (dropoff_longitude != 0 and dropoff_latitude != 0) ;

/*insert data from green cabs */
insert into trips( 
		   vendorID, 
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
	       dropoff_loc
	       )	
 	 select vendorID, 
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
	       tolls_amount,
	       'g',
	       ST_SetSRID( ST_MakePoint( pickup_longitude, pickup_latitude), 4326) as pickup_loc,
	       ST_SetSRID( ST_MakePoint( dropoff_longitude, dropoff_latitude), 4326) as dropoff_loc
	from green_trips
	where (pickup_longitude != 0 and pickup_latitude != 0) or 
	      (dropoff_longitude != 0 and dropoff_latitude != 0) ;