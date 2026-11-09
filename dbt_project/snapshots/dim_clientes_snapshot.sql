{% snapshot dim_clientes_snapshot %}

{{
    config(
      target_schema='gold',
      unique_key='id_cliente',
      strategy='check',
      check_cols=['nombre_cliente', 'ciudad', 'email']
    )
}}

SELECT * FROM {{ ref('dim_clientes') }}

{% endsnapshot %}