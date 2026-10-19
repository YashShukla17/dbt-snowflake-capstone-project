__dbt__cte__airports_with_cordinates as (


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

)