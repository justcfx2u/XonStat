This is the source code of qlstats, a website for tracking Quake Live player statistics.
The source is based on xonstat, the stats tracking site for Xonotic, and was modified and enhanced for handling Quake Live.

System overview
===
qlstats is a set of several components:
- postgresql: The database system storing all the data (except some configuration), running on version 9.4
- nginx: public facing HTTP server, used to dispatch incoming URLs to "xonstat" and "feeder" processes, also taking care of SSL encryption and throttling
- xonstat: The process hosting the main web site, inherited from the xonstat project, written in python
- feeder: nodejs server process(es), which fulfill several tasks, based on the(ir) config:
  - connect to QL server ZMQ stats port to receive stats data
  - convert the stats data from QL JSON format to the xonstat submission format and upload it to the xonstat submission.py
  - "gamerating" module to calculate glicko rating updates for the players in the matches
  - "webadmin" module with the game server self-administration panel
  - "webapi" module with public and internal APIs, like enriched server browser information, player localization, ...
  - "webui" module hosting the parts of the website that require a login
- cronjobs: scheduled maintenance scripts to 
  - update ranking lists
  - assign regions to game servers through geo-ip lookup
  - assign regions to players based on the servers they played on

nginx is the only publicly accessible server process. All other processes are bound to IP 127.0.0.1.
In this repository you can find nginx, xonstat and feeder config files for "qlstats.net" (production) and "qlstats.local" (development).

The production setup runs 5 feeder processes with different modules enabled, while in a local setup one feeder runs all modules.
The nodejs "zmq" library has a limitation that it can only handle up to 342 zmq connection per process, so qlstats runs 4 feeder processes to handle more QL servers.
In the production setup feeder #1 runs the webui, feeders 1-4 have listen to game server zmq messges, host the various webadmin panels and an internal web API.
A 5th feeder process just runs the "webapi", which aggregates live data from the other 4 feeders through the internal API.

The local setup for development uses only a single feeder process that runs all the modules (but only allows up to 342 QL servers to be monitored).


nginx
---
nginx is setup to redirect almost all plain HTTP requests to HTTPS. Exceptions are public API URLs to provide backward compatibility.
Incoming requests are forwarded to xonstat and feeder processes based on URL prefixes:
/account: feeder 1 running the webui
/panel1: feeder 1 running webadmin
/panel2: feeder 2 running webadmin
/panel3: feeder 3 running webadmin
/panel4: feeder 4 running webadmin
/api: feeder 5 running webapi
api.qlstats.net/*: redirected to /api/*. This legacy subdomain only exists for backward compatibility
all other URLs: xonstat

xonstat (aka paster)
---
This process is started automatically by a crontab entry to launch cronjobs/paster.sh.
The web server listens on 127.0.0.1:8080

feeder
---
Feeders are started automatically by a crontab entry to launch cronjobs/feeder.sh.  
Feeders 1-4 run on 127.0.0.1:8081 to 8084 and use config files cfg1.json - cfg4.json.  
Another feeder process runs on port 8088 and uses config file cfg_api.json. It only runs the "webapi" module and no actual QL server data feed.  
Feeder process are started from within the xonstat/feeder directory with command line "node feeder.node.js -c cfgX.json".


local setup (for development)
===
To use the local setup, you need to add an entry to your /etc/hosts (or %windir%\System32\drivers\etc\hosts) file: qlstats.local 127.0.0.1

Use the nginx/qlstats.local/nginx.conf file to configure your local nginx server. It will handle requests for "http(s)://qlstats.local/" URLs and
forward them to the local backend processes.

To start the "xonstat" main web server, use "paster serve local.ini" from within the xonstat directory.

To start the "feeder", use "node feeder.node.js -c local.json"



----

Project is licensed GPLv2+.
