{% macro calculate_distances(airport_code) %}
  with origin as (
    select airport_code, longitude, latitude, airport_cordinates from {{ ref('airports_with_cordinates') }}
    where airport_code = '{{ airport_code }}'
    limit 1
  ), sort_by_distance as (
    select a.city,a.airport_code,
    a.airport_cordinates, 
    ST_DISTANCE(o.airport_cordinates, a.airport_cordinates) /1000 as distance_in_km
     from {{ ref('airports_with_cordinates') }} as a 
    cross join origin  as o
    where a.airport_code not in ( '{{ airport_code }}' )
  )
  select * from sort_by_distance order by distance_in_km 
{% endmacro %}