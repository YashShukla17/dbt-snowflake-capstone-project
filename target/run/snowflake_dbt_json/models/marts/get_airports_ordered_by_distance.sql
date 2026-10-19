
  create or replace   view dbt_captsone.raw.get_airports_ordered_by_distance
  
  
  
  
  as (
    
  with  __dbt__cte__airports_with_cordinates as (


with source as (
    select * from dbt_captsone.raw.stg_airports
), transformed as (
    select 
       -- md5(cast(coalesce(cast(city as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(airport_code as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as id, 
        city,
        airport_code,
        country,
        latitude,
        longitude,
        ST_MAKEPOINT(longitude, latitude) as airport_cordinates
     from source
)
SELECT 
    *,
    current_timestamp() as inserted_date,
    'admin' as inserted_by

 FROM transformed
), origin as (
    select airport_code, longitude, latitude, airport_cordinates from __dbt__cte__airports_with_cordinates
    where airport_code = 'ATL'
    limit 1
  ), sort_by_distance as (
    select a.city,a.airport_code,
    a.airport_cordinates, 
    ST_DISTANCE(o.airport_cordinates, a.airport_cordinates) /1000 as distance_in_km
     from __dbt__cte__airports_with_cordinates as a 
    cross join origin  as o
    where a.airport_code not in ( 'ATL' )
  )
  select * from sort_by_distance order by distance_in_km 

  );

