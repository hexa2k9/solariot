FROM rockylinux:8-minimal

RUN set -eux \
    && microdnf module enable python39:3.9 \
    && microdnf distro-sync \
    && microdnf install python39 shadow-utils \
    && microdnf clean all

RUN set -eux \
    && pip3 install --no-cache-dir virtualenv \
    && groupadd -r -g 2000 solariot \
    && adduser -r -M -u 2000 -g solariot solariot

ADD --chown=solariot:solariot . /solariot

WORKDIR /solariot

USER solariot

RUN set -eux \
    && virtualenv .venv \
    && /solariot/.venv/bin/pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/solariot/.venv/bin/python", "solariot.py"]
