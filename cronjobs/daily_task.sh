#!/bin/sh
set curdir=`pwd`
set pgpassword=xonstat
cd `dirname $0`/..
psql -U xonstat -w xonstatdb <sql/update_player_region.sql
psql -U xonstat -w xonstatdb <sql/update_ranks.sql
psql -U xonstat -w xonstatdb <sql/purge_deleted_steamids.sql
cd "$curdir"
