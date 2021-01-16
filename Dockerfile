FROM python:3.8-alpine

# env - paths
ENV USER="ansible"
ENV GROUP="ansible"
ENV HOME="/home/$USER"
ENV APP_HOME="$HOME/work"
ENV PATH="$HOME/env/bin:$PATH"
ENV VIRTUAL_ENV="$HOME/env"

# env - python tweeking
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# create directories
RUN mkdir "$HOME" "$APP_HOME" "$APP_HOME/static"

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
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && runDeps="$(scanelf --needed --nobanner --recursive / \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps

# set entrypoint
ENTRYPOINT ["ansible-playbook"]
