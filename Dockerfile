FROM ubuntu:16.04
MAINTAINER Kristofor Carle <kris@maphubs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget git curl libssl-dev openssl nano unzip python build-essential g++ gdal-bin && \
    curl -sL https://deb.nodesource.com/setup_4.x | bash && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs yarn && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /var/tessera

WORKDIR /var/tessera

#install tessera
COPY package.json yarn.lock /var/tessera/
RUN yarn install --production --pure-lockfile

COPY ./configs /var/tessera/configs
COPY ./config.json /var/tessera/config.json

COPY ./docker-entrypoint.sh /var/tessera/docker-entrypoint.sh
RUN chmod +x /var/tessera/docker-entrypoint.sh

ENTRYPOINT ["/var/tessera/docker-entrypoint.sh"]
