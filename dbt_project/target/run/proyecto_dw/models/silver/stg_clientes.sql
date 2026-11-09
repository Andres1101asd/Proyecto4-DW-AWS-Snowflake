
  create or replace   view db_proyecto4.silver.stg_clientes
  
  
  
  
  as (
    SELECT 
    id_cliente,
    nombre,
    email,
    ciudad,
    fecha_registro
FROM db_proyecto4.oltp.clientes
  );

