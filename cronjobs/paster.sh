#!/bin/sh
cd ~xonstat/xonstat
killall paster
paster serve development.ini

