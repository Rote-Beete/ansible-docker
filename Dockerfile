FROM python:3.8-alpine

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

ENTRYPOINT ["ansible-playbook"]
