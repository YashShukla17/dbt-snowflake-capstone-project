



select 
md5(cast(coalesce(cast(airport_code as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(city as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as id
,airport_code,city,country from dbt_captsone.raw.stg_airports

