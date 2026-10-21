
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from dbt_captsone.raw.stg_airports

where not(longitude )


  
  
      
    ) dbt_internal_test