SELECT 
    id_cliente,
    nombre,
    email,
    ciudad,
    fecha_registro
FROM {{ source('oltp', 'clientes') }}