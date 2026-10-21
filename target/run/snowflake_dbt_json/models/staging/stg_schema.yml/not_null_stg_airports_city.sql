
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select city
from dbt_captsone.raw.stg_airports
where city is null



  
  
      
    ) dbt_internal_test