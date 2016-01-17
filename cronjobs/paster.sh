#!/bin/sh
cd ~xonstat/xonstat
killall paster 2>/dev/null
export PYTHONPATH=/home/xonstat/xonstat/lib/python
paster serve development.ini & >>paster.log

