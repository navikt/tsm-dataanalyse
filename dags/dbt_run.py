from airflow import DAG
from airflow.models import Variable
from datetime import datetime
from airflow_dbt_operator import dbt_operator


with DAG(
    dag_id="tsm_dataanalyse_dbt_run",
    start_date=datetime(2026, 6, 11),
    schedule_interval=None,
    catchup=False
) as dag:
    dbt_run_dev = dbt_operator(
        dag=dag,
        name="dbt_run_dev",
        dbt_command="run --select staging",
        dbt_target="dev",
        dbt_database=Variable.get("DBT_DATABASE_DEV"),
        dbt_location=Variable.get("DBT_LOCATION"),
        dbt_impersonate_sa=Variable.get("DBT_IMPERSONATE_SA")
    )
    dbt_run_dev
