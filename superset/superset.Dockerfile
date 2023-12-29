FROM apache/superset:3.1.0rc3-py310

COPY docker-init.sh /app/docker/docker-init.sh
COPY pythonpath_dev /app/docker/pythonpath_dev
COPY docker-bootstrap.sh /app/docker/docker-bootstrap.sh
COPY requirements.txt /app/docker/requirements.txt

USER root
RUN pip install -v --no-cache -r /app/docker/requirements.txt
USER superset
