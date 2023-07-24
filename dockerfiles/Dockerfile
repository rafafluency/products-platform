FROM python@sha256:e1d7fc61bb8a17c5a366c7a63c156e0ba1215e4d0dcee71ee85010be64bc51a0 as poetry

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /dependencies

RUN pip install poetry==1.4.2

COPY poetry.lock pyproject.toml /dependencies/

RUN poetry export --without-hashes --only main -f requirements.txt >> requirements.txt

# --------------------------------------------------------------------

FROM amazon/aws-lambda-python:3.10 as application

COPY --from=poetry /dependencies/requirements.txt requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

COPY src "${LAMBDA_TASK_ROOT}/"
