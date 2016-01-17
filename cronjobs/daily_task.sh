#!/bin/sh
set curdir=`pwd`
set pgpassword=xonstat
cd `dirname $0`/../..
psql -U xonstat -w xonstatdb <xonstat/sql/update_player_region.sql
psql -U xonstat -w xonstatdb <xonstatdb/scripts/update_ranks.sql
cd "$curdir"
