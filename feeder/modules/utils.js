var 
  pg = require("pg"),
  Q = require("q");

exports.dbConnect = dbConnect;
exports.dbClose = dbClose;
exports.strippedNick = strippedNick;

var initialized = false;

var pool;

// connect to the DB
function dbConnect(conn) {
  // this hack prevents node-postgres from applying the local time offset to timestaps that are already in UTC 
  // see: https://github.com/brianc/node-postgres/issues/429#issuecomment-24870258
  if (!initialized) {
    pool = new pg.Pool({ connectionString: conn });
    pg.types.setTypeParser(1114, function (stringValue) {
      return new Date(Date.parse(stringValue + "+0000"));
    });
    initialized = true;
  }

  var defConnect = Q.defer();
  pool.connect(function (err, cli, release) {
    if (err)
      defConnect.reject(new Error("failed to connect to postgreSQL: " + err));
    else {
      cli.release = release;
      defConnect.resolve(cli);
    }
  });
  return defConnect.promise;
}

function dbClose() {
  if (pool)
    pool.end();
}

/**
 * Remove color coding from nicknames (^1Nic^7k => Nick)
 * @param {string} nick
 */
function strippedNick(nick) {
  var stripped = "";
  var i, c;
  for (i = 0; i < nick.length; i++) {
    if (nick[i] === "^")
      i++;
    else
      stripped += nick[i];
  }
  return stripped;
}
