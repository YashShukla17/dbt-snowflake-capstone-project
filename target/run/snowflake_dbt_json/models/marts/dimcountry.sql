
  
    

create or replace transient table dbt_captsone.raw.dimcountry
    
    
    
    
    

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
), source_raw as (
    select country, inserted_date from __dbt__cte__airports_with_cordinates
), transformed as (
    select 
    country,
    max(inserted_date) as inserted_date
    from source_raw 
    group by country
)
select 
    md5(cast(coalesce(cast(country as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as id ,
    country,
    inserted_date, 
    'admin' as inserted_by,
    null as updated_date,
    null as updated_by
 from transformed
    )
;


  