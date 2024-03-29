# Data Analysis Platform

This platform aims to facilitate analysis.

## Setting up directories

```bash
mkdir -p logs/build
```

## Setting up superset

Create a `.env.superset` file in this dir

```
ADMIN_EMAIL=example@email.com
ADMIN_FIRST_NAME=john
ADMIN_LAST_NAME=doe
ADMIN_PASSWORD=ss_web_password
ADMIN_USERNAME=ss_web_username
POSTGRES_DB=superset_db
POSTGRES_USER=ss_pg_username
POSTGRES_PASSWORD=ss_pg_password
PYTHONPATH=/app/pythonpath:/app/docker/pythonpath_dev
SQLALCHEMY_DATABASE_URI=postgresql+psycopg2://ss_pg_username:ss_pg_password@ss_db:5432/superset_db
SECRET_KEY=(output from running "openssl rand -base64 42")
```

NOTES:
* `ADMIN_PASSWORD` can't have a \$ (dollar sign) in it, or it will split that string.
    * Diagnosis tip: Run `docker compose config` to see how values are inserted into env-vars.

### Running the app with superset

Start up the system

```bash
docker compose up
```

Then, go to that host at port 8088 in your browser. If you're running it locally (or have port forwarding set up), go to [http://127.0.0.1:8088](http://127.0.0.1:8088), and if you're running it remotely, go to [http://host-name:8088](http://host-name:8088). Log in using the `ADMIN_USERNAME` and `ADMIN_PASSWORD` defined in the `.env.superset` file.

You can also access the Celery Flower interface at [http://127.0.0.1:5555](http://127.0.0.1:5555), and if you're running it remotely, go to [http://host-name:5555](http://host-name:5555) (at present, there's no authentication).

NOTE:
* This currently is set up to work over http, which is generally a bad idea for services that involve authentication. This is survivable for now as it's just being run on a private system, but maybe it's worth figuring out SSL certs on a private system, so that credentials are encrypted in transit.

## Setting up airflow

Create a `.env.airflow` file in this dir and fill it in with values like those below.

```bash
AIRFLOW_UID=whatever_you_get_from_(id -u)
POSTGRES_USER="af_pg_user"
POSTGRES_PASSWORD="af_pg_pass"
POSTGRES_DB="af_db_name"
AIRFLOW__DATABASE__SQL_ALCHEMY_CONN="postgresql+psycopg2://af_pg_user:af_pg_pass@af_db/af_db_name"
AIRFLOW__CELERY__RESULT_BACKEND="db+postgresql://af_pg_user:af_pg_pass@af_db/af_db_name"
AIRFLOW__CELERY__BROKER_URL="redis://:@redis:6379/0"
AIRFLOW__CORE__FERNET_KEY="fernet_key_as_generated_below"
AIRFLOW__CORE__ENABLE_XCOM_PICKLING="true"
AIRFLOW__WEBSERVER__SECRET_KEY="webserver_secret_key_as_generated_below"
AIRFLOW__WEBSERVER__SESSION_BACKEND="securecookie"
_AIRFLOW_WWW_USER_CREATE="true"
_AIRFLOW_WWW_USER_USERNAME="af_gui_user"
_AIRFLOW_WWW_USER_PASSWORD="af_gui_pass"
JUPYTER_CONFIG_DIR="/opt/airflow/.jupyter"
JUPYTER_DATA_DIR="/opt/airflow/.jupyter/share/jupyter"
JUPYTER_RUNTIME_DIR="/opt/airflow/.jupyter/share/jupyter/runtime"
```

Note: If you want to use special characters in passwords, you may run into issues and/or escape those special chars with [this strategy](https://docs.sqlalchemy.org/en/20/core/engines.html#escaping-special-characters-such-as-signs-in-passwords).

### Generating a Fernet key

In an env with python's `cryptography` package, generate a `AIRFLOW__CORE__FERNET_KEY` via

```bash
python -c 'from cryptography.fernet import Fernet;fk = Fernet.generate_key();print(fk.decode())'
```

or less compactly,

```python
from cryptography.fernet import Fernet

fernet_key = Fernet.generate_key()
print(fernet_key.decode())
```

Run it a few times if you want to confirm the randomness.

### Generating a secret key

Generate a decent `AIRFLOW__WEBSERVER__SECRET_KEY` via

```bash
python -c 'import secrets; print(secrets.token_hex(16))'
```

## Setting up the Data Warehouse Database

Create a `.env.dwh` file and define the following environment variables.

```bash
POSTGRES_USER="dwh_db_user"
POSTGRES_PASSWORD="dwh_db_pass"
POSTGRES_DB="dwh_db_name"
```

### Enable Airflow to connect to the DWH database

Add a line to your `.env` file that defines an [Airflow connection URI](https://airflow.apache.org/docs/apache-airflow/stable/howto/connection.html#uri-format-example) to the DWH db. This connection string will have this format, and it must start with `AIRFLOW_CONN_`.

```bash
AIRFLOW_CONN_DWH_DB='postgresql+psycopg2://dwh_db_user:dwh_db_pass@dwh_db:5432/dwh_db_name'
```

NOTE: If your `POSTGRES_PASSWORD` or `POSTGRES_USERNAME` values include special characters, you need to URL-encode them before substituting them into the above template. You can do this with a built in python function as shown below.

```python
from urllib.parse import quote_plus
print(quote_plus("dwh_db_pass1!@#$%^&*()1234567890"))
dwh_db_pass1%21%40%23%24%25%5E%26%2A%28%291234567890
```

### Enable Superset to connect the the DWH database

Log in to the Superset web interface and then follow [these instructions](https://docs.analytics-data-where-house.dev/setup/superset_setup/) to create your connection.

I'll have to figure something out to extend this to a many-user system.

## Discoveries, questions, and wisdom gained along the way:
* While you can specify dot-env files that aren't named `.env` (e.g. `.env.airflow`), I'd recommend just using the filename `.env` if you are defining a healthcheck that involves an environment variable.
    * I think I've been burned by this before; I'd like to understand this better.

