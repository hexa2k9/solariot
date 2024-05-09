FROM rockylinux:8-minimal

RUN set -eux \
    && microdnf module enable python39:3.9 \
    && microdnf distro-sync \
    && microdnf install python39 shadow-utils \
    && microdnf clean all

RUN set -eux \
    && pip3 install --no-cache-dir virtualenv \
    && groupadd -r -g 2000 work \
    && adduser -r -M -u 2000 -g work work

ADD --chown=work:work . /work

WORKDIR /work

USER work

RUN set -eux \
    && virtualenv .venv \
    && /work/.venv/bin/pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["/work/.venv/bin/python", "solariot.py"]
