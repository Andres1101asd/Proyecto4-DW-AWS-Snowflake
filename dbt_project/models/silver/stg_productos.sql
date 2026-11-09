SELECT 
    id_producto,
    nombre_producto,
    categoria,
    precio
FROM {{ source('oltp', 'productos') }}