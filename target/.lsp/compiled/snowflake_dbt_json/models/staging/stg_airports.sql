


with source as (
    select * from dbt_capstone.raw.airports_raw_dataset
), renamed as (
    select  s.value:city::varchar(20) as city,s.value:code::varchar(10) as airport_Code,
     s.value:country::varchar(20) as country,
s.value:lat::decimal(5,2) as latitude,
s.value:lon::decimal(5,2) as longitude
from airports_raw_dataset,
LATERAL FLATTEN(input => json_dataset:airports, outer=>true) as s
)
SELECT 
    -- dbt_utils.generate_surrogate_key(['city','airport_code'])
    city,
    airport_code,
    country,
    latitude,
    longitude
    -- ST_MAKEPOINT(longitude, latitude) as airport_cordinates
 FROM renamed
