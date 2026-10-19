

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

), dimairports as (
    select id, airport_code from dbt_captsone.raw.dimairports   
), 

dimcity as (
    select id, city from dbt_captsone.raw.dimcity
), 

dimcountry as (
    select id, country from dbt_captsone.raw.dimcountry
), 

airports_with_cordinates as (
    select * from __dbt__cte__airports_with_cordinates

    
    where inserted_date >= coalesce((select max(inserted_date) from dbt_captsone.raw.fact_airports), '1900-01-01')
    
), 

fact_table as (
    select 
        air.id as airport_code_id, 
        dc.id as city_id, 
        dctry.id as country_id,
        base.longitude, 
        base.latitude, 
        base.airport_cordinates, 
        base.inserted_date
    from airports_with_cordinates as base 
    join dimairports as air on air.airport_code = base.airport_code
    join dimcity as dc on dc.city = base.city
    join dimcountry as dctry on dctry.country = base.country
)

select 

    md5(cast(coalesce(cast(airport_code_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(city_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as id,

    airport_code_id,
    city_id,
    country_id,
    longitude,
    latitude,
    airport_cordinates,
    inserted_date, 
    'admin' as inserted_by 
from fact_table