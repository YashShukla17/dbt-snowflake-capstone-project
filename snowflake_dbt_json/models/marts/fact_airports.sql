{{
  config(
    materialized = 'incremental',
    unique_key = 'id',
    incremental_strategy = 'merge', 
    merge_exclude_columns = ['inserted_date','inserted_by']
  )
}}

with dimairports as (
    select id, airport_code from {{ ref('dimairports') }}   
), 

dimcity as (
    select id, city from {{ ref('dimcity') }}
), 

dimcountry as (
    select id, country from {{ ref('dimcountry') }}
), 

airports_with_cordinates as (
    select * from {{ ref('airports_with_cordinates') }}

    {% if is_incremental() %}
    where inserted_date >= coalesce((select max(inserted_date) from {{ this }}), '1900-01-01')
    {% endif %}
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

    {{ dbt_utils.generate_surrogate_key(['airport_code_id','city_id']) }} as id,

    airport_code_id,
    city_id,
    country_id,
    longitude,
    latitude,
    airport_cordinates,
    inserted_date, 
    'admin' as inserted_by 
from fact_table