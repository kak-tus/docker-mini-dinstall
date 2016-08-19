FROM debian:8

MAINTAINER Andrey Kuzmin "kak-tus@mail.ru"

COPY etc_mini-dinstall /etc/mini-dinstall
COPY check /bin/check

RUN apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
  mini-dinstall \

  && mkdir /data \
  && ln -sf /dev/stdout /data/mini-dinstall.log \

  && rm -rf /var/lib/apt/lists/*

CMD mini-dinstall -c /etc/mini-dinstall && /bin/check
