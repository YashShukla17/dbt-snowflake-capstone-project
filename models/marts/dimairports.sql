{{
  config(
    materialized = 'table',
    )
}}


with source as (
    select airport_code,dbt_valid_from, coalesce(dbt_valid_to,'2999-12-31') as valid_till from {{ ref('airport_codes') }}
) select 
    {{ dbt_utils.generate_surrogate_key(['airport_code']) }} as id,
    airport_code,
    max(dbt_valid_from) as inserted_date,
     'admin' as inserted_by
 from source where valid_till >= current_timestamp()
group by airport_code