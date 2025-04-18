FROM quay.io/astronomer/astro-runtime:12.8.0

USER root
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    python3-dev \
    libffi-dev \
    libc-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Fix permissions for dbt directory
RUN mkdir -p /usr/local/airflow/include/dbt && \
    chown -R astro:astro /usr/local/airflow/include && \
    chmod -R u+rw /usr/local/airflow/include

USER astro
# Configure soda_venv
RUN python -m venv /usr/local/airflow/soda_venv && \
    source /usr/local/airflow/soda_venv/bin/activate && \
    pip install --no-cache-dir soda-core-bigquery==3.5.2 &&\
    pip install --no-cache-dir soda-core-scientific==3.5.2 &&\
    pip install --no-cache-dir pendulum &&\
    pip install --no-cache-dir setuptools &&\
    pip install --no-cache-dir google-cloud-bigquery==3.26.0 &&\
    pip install --no-cache-dir google-cloud-bigquery-storage==2.26.0 &&\
    pip install --no-cache-dir protobuf==4.25.6 && deactivate

# Configure dbt_venv
RUN python -m venv /usr/local/airflow/dbt_venv && \
    source /usr/local/airflow/dbt_venv/bin/activate && \
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ dbt-core==1.8.2 &&\
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ dbt-bigquery==1.8.2 &&\ 
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ dbt-adapters==1.2.1 &&\
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ dbt-common>=1.1.1 &&\
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ "astronomer-cosmos[dbt-bigquery]==1.0.3" &&\
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ setuptools &&\
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ google-cloud-bigquery==3.26.0 &&\
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ google-cloud-bigquery-storage==2.26.0 &&\
    pip install --no-cache-dir -i https://pip.astronomer.io/v2/ protobuf==4.25.6 && deactivate
 