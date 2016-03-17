#!/bin/sh
cd ~xonstat/xonstat
killall paster 2>/dev/null
export PYTHONPATH=/home/xonstat/xonstat/lib/python
~xonstat/xonstat/cronjobs/autorestart.sh nohup paster serve development.ini >>paster.log 2>&1 &
