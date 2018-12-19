FROM ubuntu:16.04
MAINTAINER Kristofor Carle <kris@maphubs.com>

ENV DEBIAN_FRONTEND noninteractive

# tessera intentionally doesn't register system fonts (to encourage maps to be self-contained units).
# You can either copy Open Sans into a fonts/ directory and add font-directory: url(fonts/); to your Map element (in CartoCSS)
# or you can set MAPNIK_FONT_PATH to the location of Open Sans on your system.
ENV MAPNIK_FONT_PATH=/usr/local/share/fonts/

RUN apt-get update && apt-get install -y wget git curl libssl-dev openssl nano unzip python build-essential g++ gdal-bin

#install node, npm, pm2
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs
RUN npm install -g npm && npm install pm2 -g

#create directory
RUN mkdir -p /var/tessera
WORKDIR /var/tessera

COPY ./bin/ /var/tessera/node_modules/tessera/bin/
COPY ./lib/ /var/tessera/node_modules/tessera/lib/
COPY ./public/ /var/tessera/node_modules/tessera/public/
COPY ./server.js /var/tessera/node_modules/tessera/server.js

#Prep Data
COPY ./data/osm-2018-11-12-v3.8-europe_luxembourg.mbtiles /Users/seth/archive.mbtiles
COPY ./style/ /Users/seth/style/

#Fonts
COPY ./fonts/ /usr/local/share/fonts/
RUN apt-get install -y mercurial fontconfig
RUN fc-cache -f -v
RUN ls -hal /usr/local/share/fonts/
RUN fc-list

#TEST
# RUN head -n100 /Users/seth/style/mapbox-studio-osm-bright.tm2/project.xml

#MapBox WebGL conversion to XML
# RUN npm install -g mapnik-xml-to-mapbox-gl-json
# RUN npm install -g mapbox-gl-json-to-mapnik-xml
# #RUN chmod +x /usr/lib/node_modules/mapnik-xml-to-mapbox-gl-json
# #RUN chmod +x /usr/lib/node_modules/mapbox-gl-json-to-mapnik-xml/bin/mapbox-gl-json-to-mapnik-xml
# WORKDIR /usr/lib/node_modules/mapbox-gl-json-to-mapnik-xml/
# RUN npm install @mapbox/tilelive
# RUN npm install @mapbox/tilelive-vector
# RUN npm install @mapbox/sphericalmercator
# RUN npm install d3-queue
# RUN npm install @mapbox/tiletype
# RUN npm install uuid
# #RUN npm install
# COPY ./style/BeMobile_OpenMapTiles.json /usr/lib/node_modules/mapbox-gl-json-to-mapnik-xml/index.js
# RUN node /usr/lib/node_modules/mapbox-gl-json-to-mapnik-xml/test/test.js

#install tessera
COPY ./package.json /var/tessera/package.json
RUN npm install

COPY ./configs /var/tessera/configs
COPY ./config.json /var/tessera/config.json

COPY ./docker-entrypoint.sh /var/tessera/docker-entrypoint.sh
RUN chmod +x /var/tessera/docker-entrypoint.sh

ENTRYPOINT ["/var/tessera/docker-entrypoint.sh"]
