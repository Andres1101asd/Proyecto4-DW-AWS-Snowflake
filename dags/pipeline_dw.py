from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'Andres',
    'depends_on_past': False,
    'email_on_failure': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'pipeline_dw_proyecto4',
    default_args=default_args,
    description='Pipeline ETL Full Load + Snapshot para Proyecto 4',
    schedule='@daily',
    start_date=datetime(2026, 1, 1),
    catchup=False,
) as dag:

    # Tarea 1: Simular extracción (en un caso real aquí iría el S3 o el CDC)
    extraer_oltp = BashOperator(
        task_id='extraer_datos_oltp',
        bash_command='echo "Extrayendo datos del OLTP y cargando a la capa Bronze..."',
    )

    # Tarea 2: Ejecutar los modelos de dbt (Silver y Gold)
    transformar_dbt = BashOperator(
        task_id='dbt_run_gold_silver',
        bash_command='cd /workspaces/Proyecto4-DW-AWS-Snowflake/dbt_project && dbt run',
    )

    # Tarea 3: Ejecutar el Snapshot (SCD2)
    snapshot_dbt = BashOperator(
        task_id='dbt_snapshot_scd2',
        bash_command='cd /workspaces/Proyecto4-DW-AWS-Snowflake/dbt_project && dbt snapshot',
    )

    extraer_oltp >> transformar_dbt >> snapshot_dbt