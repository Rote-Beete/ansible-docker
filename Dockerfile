FROM python:3.8-alpine

# env - paths
ENV HOME="/usr/local/bin"
ENV PATH="$HOME/env/bin:$PATH"
ENV VIRTUAL_ENV="$HOME/env"

# env - python tweeking
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# include files
COPY requirements.txt .

# setup
RUN set -eux \
    && apk add --no-cache \
        openssh-keygen \
    && apk add --no-cache --virtual .build-deps \
        build-base \
        gcc \
        libffi-dev \
        musl-dev \
        openssl-dev \
        python3-dev \
    && python -m venv "$VIRTUAL_ENV" \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && runDeps="$(scanelf --needed --nobanner --recursive $VIRTUAL_ENV \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps

# set working dir
WORKDIR /work

# set entrypoint
ENTRYPOINT ["ansible-playbook"]
