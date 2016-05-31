FROM ubuntu:16.04
MAINTAINER Kristofor Carle <kris@maphubs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget git curl libssl-dev openssl nano unzip python build-essential g++ gdal-bin

#install node, npm, pm2
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash
RUN apt-get install -y nodejs
RUN npm install -g npm && npm install pm2 -g

#create directory
RUN mkdir -p /var/tessera
WORKDIR /var/tessera

#install tessera
COPY ./package.json /var/tessera/package.json
RUN npm install

COPY ./configs /var/tessera/configs
COPY ./config.json /var/tessera/config.json

COPY ./docker-entrypoint.sh /var/tessera/docker-entrypoint.sh
RUN chmod +x /var/tessera/docker-entrypoint.sh

ENTRYPOINT ["/var/tessera/docker-entrypoint.sh"]
