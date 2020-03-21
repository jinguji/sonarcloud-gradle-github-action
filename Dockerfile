FROM gradle:jdk11

RUN apt update \
  && apt install -y --no-install-recommends \
    jq \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
