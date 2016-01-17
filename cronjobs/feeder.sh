#!/bin/sh
cd ~xonstat/xonstat/feeder
killall feeder 2>/dev/null
node feeder.node.js -c cfg.json & >>feeder.log
