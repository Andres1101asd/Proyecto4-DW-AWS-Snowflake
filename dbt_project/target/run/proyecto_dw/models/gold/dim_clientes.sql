
  
    

create or replace transient table db_proyecto4.silver.dim_clientes
    
    
    
    
    

    as (SELECT DISTINCT
    id_cliente,
    nombre AS nombre_cliente,
    ciudad,
    email
FROM db_proyecto4.silver.stg_clientes
    )
;


  