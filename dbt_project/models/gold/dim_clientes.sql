SELECT DISTINCT
    id_cliente,
    nombre AS nombre_cliente,
    ciudad,
    email
FROM {{ ref('stg_clientes') }}