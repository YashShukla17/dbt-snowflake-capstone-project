{{
  config(
    materialized = 'incremental',
    unique_key = 'id'
    )
}}

with source_raw as (
    select city, inserted_date from {{ ref('airports_with_cordinates') }}
    
    {% if is_incremental() %}
    where inserted_date >= coalesce((select max(inserted_date) from {{ this }}), '1900-01-01')
    {% endif %}
), source as 
(
    select city, max(inserted_date) as inserted_date from source_raw group by city
),
 transformed as (
    select 
    {{ dbt_utils.generate_surrogate_key(['city']) }} as id,
     city,
     1::boolean as isactive,
     current_timestamp() as inserted_date,
     'admin' as inserted_by,
    null as updated_date,
    null as updated_by
    from source 
    
)
select * from transformed
