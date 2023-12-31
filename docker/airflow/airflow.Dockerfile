FROM apache/airflow:2.8.0-python3.11
USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
        jq \
        vim \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
USER airflow
COPY requirements.txt /requirements.txt
RUN pip install --user --upgrade pip
RUN pip install -v --no-cache-dir --user -r /requirements.txt
