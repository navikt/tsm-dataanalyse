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
    dbt_run = dbt_operator(
        dag=dag,
        name="dbt_run",
        dbt_command="run",
        dbt_target=Variable.get("DBT_TARGET"),
        dbt_database=Variable.get("DBT_DATABASE"),
        dbt_location=Variable.get("DBT_LOCATION"),
        dbt_impersonate_sa=Variable.get("DBT_IMPERSONATE_SA")
    )
    dbt_run
