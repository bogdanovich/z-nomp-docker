FROM debian:jessie

LABEL maintainer="Anton Bogdanovich <anton@bogdanovich.co>"

ENV ZNOMP_USER=znomp \
    ZNOMP_HOME=/znomp

ARG GOSU_VERSION=1.7

RUN useradd -d "$ZNOMP_HOME" -U "$ZNOMP_USER" \
    && mkdir -p "$ZNOMP_HOME" \
    && chown -R "$ZNOMP_USER:$ZNOMP_USER" "$ZNOMP_HOME" \
    && apt-get update && apt-get install -y --no-install-recommends \
      wget git build-essential libsodium-dev npm nano vim telnet curl \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && npm install n -g && n stable \
    && git clone https://github.com/bogdanovich/z-nomp \
    && cd z-nomp \
    && npm update && npm install 

VOLUME ["$ZNOMP_HOME/pool_configs"]
EXPOSE 8080 3032

WORKDIR z-nomp
COPY config.json docker-entrypoint.sh ./
COPY pool_configs ./pool_configs
ENTRYPOINT ["./docker-entrypoint.sh"]
RUN chmod a+rx ./docker-entrypoint.sh 