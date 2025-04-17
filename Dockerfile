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

USER astro
RUN python -m venv soda_venv && source soda_venv/bin/activate && \
    pip install --no-cache-dir soda-core-bigquery==3.5.2 &&\
    pip install --no-cache-dir soda-core-scientific==3.5.2 && deactivate
