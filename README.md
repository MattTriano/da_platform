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



