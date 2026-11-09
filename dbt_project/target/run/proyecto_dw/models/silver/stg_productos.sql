
  create or replace   view db_proyecto4.silver.stg_productos
  
  
  
  
  as (
    SELECT 
    id_producto,
    nombre_producto,
    categoria,
    precio
FROM db_proyecto4.oltp.productos
  );

