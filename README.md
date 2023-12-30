# Data Analysis Platform

This platform aims to facilitate analysis.

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

NOTE:
* This currently is set up to work over http, which is generally a bad idea for services that involve authentication. This is survivable for now as it's just being run on a private system, but maybe it's worth figuring out SSL certs on a private system, so that credentials are encrypted in transit.

## Setting up airflow

Create a `.env.airflow` file in this dir

```bash
POSTGRES_USER=airflow_metadata_db_username
POSTGRES_PASSWORD=airflow_metadata_db_password 
POSTGRES_DB=airflow_metadata_db

AIRFLOW__CELERY__RESULT_BACKEND=db+postgresql://airflow_metadata_db_username:airflow_metadata_db_password@airflow_db/airflow_metadata_db
AIRFLOW__CELERY__BROKER_URL=redis://:@redis:6379/0
AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow_metadata_db_username:airflow_metadata_db_password@airflow_db/airflow_metadata_db
AIRFLOW_UID=1000
_AIRFLOW_WWW_USER_USERNAME=airflow_web_gui_username
_AIRFLOW_WWW_USER_PASSWORD=airflow_web_gui_password
AIRFLOW__CORE__FERNET_KEY=fernet_key_as_generated_below
AIRFLOW__CORE__ENABLE_XCOM_PICKLING=True
AIRFLOW__WEBSERVER__SECRET_KEY=webserver_secret_key_as_generated_below
AIRFLOW__WEBSERVER__SESSION_BACKEND=securecookie
JUPYTER_CONFIG_DIR="/opt/airflow/.jupyter"
JUPYTER_DATA_DIR="/opt/airflow/.jupyter/share/jupyter"
JUPYTER_RUNTIME_DIR="/opt/airflow/.jupyter/share/jupyter/runtime"
```

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

## Setting up directories

```bash
mkdir -p logs/build logs/airflow
```

