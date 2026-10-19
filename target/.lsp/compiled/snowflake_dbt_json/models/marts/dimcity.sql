

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

), source_raw as (
    select city, inserted_date from __dbt__cte__airports_with_cordinates
    
    
    where inserted_date >= coalesce((select max(inserted_date) from dbt_captsone.raw.dimcity), '1900-01-01')
    
), source as 
(
    select city, max(inserted_date) as inserted_date from source_raw group by city
),
 transformed as (
    select 
    md5(cast(coalesce(cast(city as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as id,
     city,
     1::boolean as isactive,
     current_timestamp() as inserted_date,
     'admin' as inserted_by,
    null as updated_date,
    null as updated_by
    from source 
    
)
select * from transformed