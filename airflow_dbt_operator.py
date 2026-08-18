from airflow import DAG
from dataverk_airflow import python_operator


def dbt_operator(*, dag: DAG, name: str, dbt_command: str, dbt_target: str, dbt_database: str, dbt_impersonate_sa: str, retries: int = 1):
    return python_operator(
        dag=dag,
        name=name,
        repo="navikt/tsm-dataanalyse",
        branch="main",
        script_path="dbt/dbt_run_airflow.py",
        extra_envs={
            "dbt_command": dbt_command,
            "DBT_TARGET": dbt_target,
            "DBT_DATABASE": dbt_database,
            "DBT_IMPERSONATE_SA": dbt_impersonate_sa
        },
        use_uv_pip_install=True,
        requirements_path="requirements_airflow.txt",
        python_version="3.12",
        allowlist=["bigquery.googleapis.com"],
        startup_timeout_seconds=600,
        slack_channel="#team-symfoni-airflow-alerts",
        retries=retries,
    )
