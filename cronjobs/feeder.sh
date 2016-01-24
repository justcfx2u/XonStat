#!/bin/sh
cd ~xonstat/xonstat/feeder
killall node 2>/dev/null
nohup node feeder.node.js -c cfg.json >>feeder.log 2>&1 &
