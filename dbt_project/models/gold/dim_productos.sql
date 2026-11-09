SELECT DISTINCT
    id_producto,
    nombre_producto,
    categoria
FROM {{ ref('stg_productos') }}