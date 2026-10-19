


with source as (
    select airport_code,dbt_valid_from, coalesce(dbt_valid_to,'2999-12-31') as valid_till from dbt_captsone.raw.airport_codes
) select 
    md5(cast(coalesce(cast(airport_code as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as id,
    airport_code,
    max(dbt_valid_from) as inserted_date,
     'admin' as inserted_by
 from source where valid_till >= current_timestamp()
group by airport_code