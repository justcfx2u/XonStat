#!/bin/sh
cd ~xonstat/xonstat/feeder
killall feeder
node feeder.node.js -c cfg.json
