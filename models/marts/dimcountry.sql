{{
  config(
    materialized = 'table'
    )
}}


with source_raw as (
    select country, inserted_date from {{ ref('airports_with_cordinates') }}
), transformed as (
    select 
    country,
    max(inserted_date) as inserted_date
    from source_raw 
    group by country
)
select 
    {{ dbt_utils.generate_surrogate_key(['country']) }} as id ,
    country,
    inserted_date, 
    'admin' as inserted_by,
    null as updated_date,
    null as updated_by
 from transformed
