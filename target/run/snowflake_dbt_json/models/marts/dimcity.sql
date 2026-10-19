-- back compat for old kwarg name
  
  begin;
    
        
            
            
            
            
        
    

    

    merge into dbt_captsone.raw.dimcity as DBT_INTERNAL_DEST
        using dbt_captsone.raw.dimcity__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.id = DBT_INTERNAL_DEST.id))

    
    when matched then update set
        "ID" = DBT_INTERNAL_SOURCE."ID","CITY" = DBT_INTERNAL_SOURCE."CITY","ISACTIVE" = DBT_INTERNAL_SOURCE."ISACTIVE","INSERTED_DATE" = DBT_INTERNAL_SOURCE."INSERTED_DATE","INSERTED_BY" = DBT_INTERNAL_SOURCE."INSERTED_BY","UPDATED_DATE" = DBT_INTERNAL_SOURCE."UPDATED_DATE","UPDATED_BY" = DBT_INTERNAL_SOURCE."UPDATED_BY"
    

    when not matched then insert
        ("ID", "CITY", "ISACTIVE", "INSERTED_DATE", "INSERTED_BY", "UPDATED_DATE", "UPDATED_BY")
    values
        ("ID", "CITY", "ISACTIVE", "INSERTED_DATE", "INSERTED_BY", "UPDATED_DATE", "UPDATED_BY")

;
    commit;