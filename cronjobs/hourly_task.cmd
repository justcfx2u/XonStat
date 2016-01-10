@echo off
set curdir=%cd%
cd /d "%~dp0"
cd ..\feeder
node fill-server-geoip.node.js
node feeder.node.js -e
cd %curdir%
