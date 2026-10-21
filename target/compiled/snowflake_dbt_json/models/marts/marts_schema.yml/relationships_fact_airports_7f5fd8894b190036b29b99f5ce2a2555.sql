
    
    

with child as (
    select airport_code_id as from_field
    from dbt_captsone.raw.fact_airports
    where airport_code_id is not null
),

parent as (
    select airport_code as to_field
    from dbt_captsone.raw.dimairports
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


