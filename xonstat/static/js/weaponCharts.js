// Colors assigned to the various weapons
var weaponColors = {
  "gt": "#00d8ff",
  "mg": "#ffff40",
  "sg": "#ff8100",
  "gl": "#027812",
  "rl": "#ff0000",
  "lg": "#ffffb0",
  "rg": "#14c513",
  "pg": "#c500ff",
  "hmg": "#cea500",
  "bfg": "#015aff",
  //"ng": "#666666",
  //"cg": "#bbbbbb",
  //"pm": "#ffaaee"
};

// Flatten the existing weaponstats JSON requests
// to ease indexing
var flatten = function (weaponData) {
  flattened = {}

  // each game is a key entry...
  weaponData.games.forEach(function (e, i) { flattened[e] = {}; });

  // ... with indexes by weapon_cd
  weaponData.weapon_stats.forEach(function (e, i) { flattened[e.game_id][e.weapon_cd] = e; });

  return flattened;
}

// Calculate the Y value for a given weapon stat
function accuracyValue(gameWeaponStats, weapon) {
  if (gameWeaponStats[weapon] == undefined) {
    return null;
  }
  var ws = gameWeaponStats[weapon];
  var pct = ws.fired < 10 ? Number.NaN : Math.round((ws.hit / ws.fired) * 100);

  return pct;
}

// Calculate the tooltip text for a given weapon stat
function accuracyTooltip(weapon, pct, averages, gameWeaponStats) {
  if (pct == null) {
    return null;
  }

  var ws = gameWeaponStats[weapon];
  var tt = weapon.toUpperCase() + ": " + pct.toString() + "% [" + ws.hit + "/" + ws.fired + "]";
  if (averages[weapon] != undefined) {
    return tt + " (" + averages[weapon].toString() + "% average)";
  }

  return tt;
}

// Draw the accuracy chart in the "accuracyChart" div id
function drawAccuracyChart(weaponData) {

  var data = new google.visualization.DataTable();
  data.addColumn('string', 'X');
  for (w in weaponColors) {
    data.addColumn('number', w.toUpperCase());
    data.addColumn({ type: 'string', role: 'tooltip' });
  }

  var flattened = flatten(weaponData);

  for (i in weaponData.games) {
    var game_id = weaponData.games[i];
    var row = [game_id.toString()];
    var ws = flattened[game_id];
    for (w in weaponColors) {
      var acc = accuracyValue(ws, w);
      var tt = accuracyTooltip(w, acc, weaponData.averages, ws);
      row.push(acc);
      row.push(tt);
    }
    data.addRow(row);
  }

  var options = getOptions(false);
  options.lineWidth = 2;

  var chart = new google.visualization.LineChart(document.getElementById('accuracyChart'));

  // a click on a point sends you to that games' page
  var accuracySelectHandler = function (e) {
    var selection = chart.getSelection()[0];
    if (selection != null && selection.row != null) {
      var game_id = data.getFormattedValue(selection.row, 0);
      window.location.href = "/game/" + game_id.toString();
    }
  };
  google.visualization.events.addListener(chart, 'select', accuracySelectHandler);

  chart.draw(data, options);
}

function getOptions(addGauntlet) {
  var series = {};
  var i = 0;
  for (var w in weaponColors)
    series[i++] = { color: weaponColors[w] };

  return {
    backgroundColor: { fill: 'transparent' },
    legend: {
      textStyle: { color: "#eee" },
      position: "top"
    },
    hAxis: {
      title: 'Games',
      textPosition: 'none',
      titleTextStyle: { color: '#eee' },
      textStyle: { color: "#888" }
    },
    vAxis: {
      title: 'Percentage',
      titleTextStyle: { color: '#eee' },
      textStyle: { color: "#888" },
      minValue: 0,
      maxValue: 100,
      baselineColor: '#eee',
      gridlineColor: '#888',
      ticks: [20, 40, 60, 80, 100]
    },
    series: series,
    interpolateNulls: true
  };
}

// Calculate the damage Y value for a given weapon stat
function damageValue(weapon, gameWeaponStats) {
  if (gameWeaponStats[weapon] == undefined) {
    return null;
  }
  return gameWeaponStats[weapon].frags;
}

// Calculate the damage tooltip text for a given weapon stat
function damageTooltip(weapon, ws, pct) {
  if (pct == null) {
    return null;
  }
  if (!ws[weapon])
    return weapon.toUpperCase() + ": not used";
  var frags = ws[weapon].frags;
  return weapon.toUpperCase() + ": " + frags + (frags == 1 ? " kill" : " kills") + " (" + Math.round(pct).toString() + "%)";
}

// Draw the damage chart into the "damageChart" div id
function drawDamageChart(weaponData) {

  var data = new google.visualization.DataTable();
  data.addColumn('string', 'X');
  for (w in weaponColors) {
    data.addColumn('number', w.toUpperCase());
    data.addColumn({ type: 'string', role: 'tooltip' });
  }

  var flattened = flatten(weaponData);

  for (i in weaponData.games) {
    var game_id = weaponData.games[i];
    var row = [game_id.toString()];
    var ws = flattened[game_id];

    var totalFrags = 0;
    for (var w in ws) {
      var frags = parseInt(ws[w].frags) || 0;
      totalFrags += frags;
    }
    totalFrags /= 100.0;

    for (w in weaponColors) {
      var pct = damageValue(w, ws) / totalFrags;
      var tt = damageTooltip(w, ws, pct);
      row.push(pct);
      row.push(tt);
    }
    data.addRow(row);
  }

  var options = getOptions(true);
  options.legend.maxLines = 3;
  options.isStacked = true;

  var chart = new google.visualization.ColumnChart(document.getElementById('damageChart'));

  // a click on a point sends you to that game's page
  var damageSelectHandler = function (e) {
    var selection = chart.getSelection()[0];
    if (selection != null && selection.row != null) {
      var game_id = data.getFormattedValue(selection.row, 0);
      window.location.href = "/game/" + game_id.toString();
    }
  };
  google.visualization.events.addListener(chart, 'select', damageSelectHandler);

  chart.draw(data, options);
}
