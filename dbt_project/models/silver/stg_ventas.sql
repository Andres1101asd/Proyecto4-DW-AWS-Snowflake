SELECT 
    v.id_venta,
    v.id_cliente,
    v.id_producto,
    v.fecha_venta,
    v.cantidad,
    p.precio,
    (v.cantidad * p.precio) AS total_venta
FROM {{ source('oltp', 'ventas') }} v
JOIN {{ source('oltp', 'productos') }} p 
    ON v.id_producto = p.id_producto