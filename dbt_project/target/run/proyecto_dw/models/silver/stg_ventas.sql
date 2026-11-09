
  create or replace   view db_proyecto4.silver.stg_ventas
  
  
  
  
  as (
    SELECT 
    v.id_venta,
    v.id_cliente,
    v.id_producto,
    v.fecha_venta,
    v.cantidad,
    p.precio,
    (v.cantidad * p.precio) AS total_venta
FROM db_proyecto4.oltp.ventas v
JOIN db_proyecto4.oltp.productos p 
    ON v.id_producto = p.id_producto
  );

