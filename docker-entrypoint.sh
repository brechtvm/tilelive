#!/bin/sh
#pm2 start node_modules/tessera/bin/tessera.js --name tessera --no-daemon -- -c config.json -p 8080
#pm2 start node_modules/tessera/bin/tessera.js --name tessera --no-daemon -- -c config.json -p 8080
pm2 start node_modules/tessera/bin/tessera.js --name tessera --no-daemon -- --multiprocess --processes 12 -C 2048 -c config.json -p 8080
#node node_modules/tessera/bin/tessera.js http://tile.stamen.com/toner/{z}/{x}/{y}.png
