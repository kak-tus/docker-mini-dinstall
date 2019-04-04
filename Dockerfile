FROM debian:8.11-slim AS build_deb

ENV \
  CONSUL_TEMPLATE_VERSION=0.19.4 \
  CONSUL_TEMPLATE_SHA256=5f70a7fb626ea8c332487c491924e0a2d594637de709e5b430ecffc83088abc0 \
  \
  GOSU_VERSION=1.10 \
  GOSU_SHA256=5b3b03713a888cee84ecbf4582b21ac9fd46c3d935ff2d7ea25dd5055d302d3c

RUN \
  apt-get update \
  \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
    curl \
    unzip \
  \
  && cd /usr/local/bin \
  && curl -L https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && echo -n "$CONSUL_TEMPLATE_SHA256  consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip" | sha256sum -c - \
  && unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
  \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && curl -L "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" -o /usr/local/bin/gosu \
  && echo -n "$GOSU_SHA256  /usr/local/bin/gosu" | sha256sum -c - \
  && chmod +x /usr/local/bin/gosu

FROM debian:8.11-slim

RUN \
  apt-get update \
  \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    build-essential \
    mini-dinstall \
  \
  && rm -rf /var/lib/apt/lists/*

ENV \
  VAULT_ADDR= \
  VAULT_TOKEN= \
  \
  USER_UID=1000 \
  USER_GID=1000 \
  \
  IN_PATH=/alloc/data/essi \
  OUT_PATH=/alloc/data/deb

COPY --from=build_deb /usr/local/bin/gosu /usr/local/bin/gosu
COPY --from=build_deb /usr/local/bin/consul-template /usr/local/bin/consul-template
COPY start.sh /usr/local/bin/start.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY templates /root/templates
COPY check /bin/check
COPY sign-release.sh /usr/local/bin/sign-release.sh

CMD ["/usr/local/bin/entrypoint.sh"]
