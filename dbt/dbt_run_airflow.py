import os
import time
import logging


def dbt_run_airflow(dbt_command) -> None:
    from dbt.cli.main import dbtRunner, dbtRunnerResult

    logging.info(f"Kjører'dbt {dbt_command}'.")
    dbt_command = dbt_command.split(" ")

    os.environ["TZ"] = "Europe/Oslo"
    time.tzset()

    dbt = dbtRunner()
    output: dbtRunnerResult = dbt.invoke(["--no-use-colors", "--log-format-file", "json"] + dbt_command)

    if output.exception:
        raise output.exception
    if not output.success:
        raise Exception(output.result)


if __name__ == "__main__":
    logging.getLogger().setLevel(logging.INFO)
    dbt_command = os.environ.get("dbt_command", "run")
    dbt_run_airflow(dbt_command)
