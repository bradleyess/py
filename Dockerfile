# - - - - - - - - - -
# B A S E   S T A G E
# - - - - - - - - - -
FROM python:3.11.2-bullseye as base
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
# Create vscode user/group and give ownership of app.
RUN groupadd -r vscode && useradd -r -m -g vscode vscode && chown -R vscode:vscode /app

# Install Poetry.
# We use pip even though it is not recommended such that we can pin the poetry version.
# See: https://python-poetry.org/docs/#installation
RUN pip install poetry==${POETRY_VERSION}

# - - - - - - - - - - -
# B U I L D   S T A G E
# - - - - - - - - - - -
FROM base as build
COPY pyproject.toml poetry.lock /app/
# Install dependencies
RUN poetry config virtualenvs.in-project true && poetry install --no-interaction --no-ansi --no-root