SELECT 
    v.id_venta,
    v.id_cliente,
    v.id_producto,
    v.fecha_venta,
    v.cantidad,
    v.precio,
    v.total_venta
FROM db_proyecto4.silver.stg_ventas v