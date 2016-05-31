#!/bin/sh
pm2 start node_modules/tessera/bin/tessera.js --name tessera --no-daemon -- -c config.json -p $TESSERA_PORT
