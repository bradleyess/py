FROM python:3.10.0 as base
ARG ENVIRONMENT=local
ENV ENVIRONMENT=${ENVIRONMENT} \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.4.2
WORKDIR /app

FROM base as build
RUN pip install poetry==${POETRY_VERSION} && \
    poetry config virtualenvs.in-project true
COPY pyproject.toml poetry.lock /app/
RUN poetry install --no-dev --no-interaction --no-root

FROM python:3.9.7-slim as runtime
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app
ENV PATH=/app/.venv/bin:$PATH
COPY --from=build /app/.venv /app/.venv
COPY . /app