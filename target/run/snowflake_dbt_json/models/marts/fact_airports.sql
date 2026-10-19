-- back compat for old kwarg name
  
  begin;
    
        
            
            
            
            
        
    

    

    merge into dbt_captsone.raw.fact_airports as DBT_INTERNAL_DEST
        using dbt_captsone.raw.fact_airports__dbt_tmp as DBT_INTERNAL_SOURCE
        on ((DBT_INTERNAL_SOURCE.id = DBT_INTERNAL_DEST.id))

    
    when matched then update set
        "ID" = DBT_INTERNAL_SOURCE."ID","AIRPORT_CODE_ID" = DBT_INTERNAL_SOURCE."AIRPORT_CODE_ID","CITY_ID" = DBT_INTERNAL_SOURCE."CITY_ID","COUNTRY_ID" = DBT_INTERNAL_SOURCE."COUNTRY_ID","LONGITUDE" = DBT_INTERNAL_SOURCE."LONGITUDE","LATITUDE" = DBT_INTERNAL_SOURCE."LATITUDE","AIRPORT_CORDINATES" = DBT_INTERNAL_SOURCE."AIRPORT_CORDINATES"
    

    when not matched then insert
        ("ID", "AIRPORT_CODE_ID", "CITY_ID", "COUNTRY_ID", "LONGITUDE", "LATITUDE", "AIRPORT_CORDINATES", "INSERTED_DATE", "INSERTED_BY")
    values
        ("ID", "AIRPORT_CODE_ID", "CITY_ID", "COUNTRY_ID", "LONGITUDE", "LATITUDE", "AIRPORT_CORDINATES", "INSERTED_DATE", "INSERTED_BY")

;
    commit;