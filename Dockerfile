FROM debian:8

MAINTAINER Andrey Kuzmin "kak-tus@mail.ru"

COPY mini-dinstall /etc/mini-dinstall
COPY check /bin/check

ENV GOSU_VERSION 1.10

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
  mini-dinstall build-essential ca-certificates wget \

  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && chmod +x /usr/local/bin/gosu \

  && apt-get purge -y --auto-remove ca-certificates wget \
  && rm -rf /var/lib/apt/lists/*

ENV USER_UID=1000
ENV USER_GID=1000

COPY start.sh /usr/local/bin/start.sh

CMD /usr/local/bin/start.sh
