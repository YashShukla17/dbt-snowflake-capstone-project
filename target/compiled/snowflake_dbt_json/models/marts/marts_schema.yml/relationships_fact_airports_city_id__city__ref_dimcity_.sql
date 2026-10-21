
    
    

with child as (
    select city_id as from_field
    from dbt_captsone.raw.fact_airports
    where city_id is not null
),

parent as (
    select city as to_field
    from dbt_captsone.raw.dimcity
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


