FROM python:3.12-bookworm

# DEBIAN_FRONTENT=noninteractive
# 対話が必要になるコマンドの対話を回避
RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    git \
    openssh-client

COPY requirements.txt /

RUN pip wheel --no-cache-dir --no-deps --wheel-dir /wheels -r /requirements.txt
