{{
  config(
    materialized = 'ephemeral'
    )
}}

with source as (
    select * from {{ ref('stg_airports') }}
), transformed as (
    select 
       -- {{ dbt_utils.generate_surrogate_key(['city','airport_code']) }} as id, 
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

