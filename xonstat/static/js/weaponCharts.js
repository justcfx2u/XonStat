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
  "ng": "#cccccc", 
  "cg": "#dddddd", 
  "pl": "#eeeeee"
};

// Flatten the existing weaponstats JSON requests
// to ease indexing
var flatten = function(weaponData) {
  flattened = {}

  // each game is a key entry...
  weaponData.games.forEach(function(e,i) { flattened[e] = {}; });

  // ... with indexes by weapon_cd
  weaponData.weapon_stats.forEach(function(e,i) { flattened[e.game_id][e.weapon_cd] = e; });

  return flattened;
}

// Calculate the Y value for a given weapon stat
function accuracyValue(gameWeaponStats, weapon) {
  if (gameWeaponStats[weapon] == undefined) {
    return null;
  }
  var ws = gameWeaponStats[weapon];
  var pct = ws.fired > 0 ? Math.round((ws.hit / ws.fired) * 100) : 0;
  
  return pct;
}

// Calculate the tooltip text for a given weapon stat
function accuracyTooltip(weapon, pct, averages) {
  if (pct == null) {
    return null;
  }

  var tt = weapon.toUpperCase() + ": " + pct.toString() + "%";
  if (averages[weapon] != undefined) {
    return tt + " (" + averages[weapon].toString() + "% average)"; 
  }

  return tt;
}

// Draw the accuracy chart in the "accuracyChart" div id
function drawAccuracyChart(weaponData) {

  var data = new google.visualization.DataTable();
  data.addColumn('string', 'X');
  data.addColumn('number', 'GT');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'MG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'SG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'GL');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'RL');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'LG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'RG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'PG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'HMG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'BFG');
  data.addColumn({type: 'string', role: 'tooltip'});

  var flattened = flatten(weaponData);

  for(i in weaponData.games) {
    var game_id = weaponData.games[i];
    var mg = accuracyValue(flattened[game_id], "mg");
    var mgTT = accuracyTooltip("mg", mg, weaponData.averages); 
    var sg = accuracyValue(flattened[game_id], "sg");
    var sgTT = accuracyTooltip("sg", sg, weaponData.averages);
    var gl = accuracyValue(flattened[game_id], "gl");
    var glTT = accuracyTooltip("gl", gl, weaponData.averages);
    var rl = accuracyValue(flattened[game_id], "rl");
    var rlTT = accuracyTooltip("rl", rl, weaponData.averages);
    var lg = accuracyValue(flattened[game_id], "lg");
    var lgTT = accuracyTooltip("lg", lg, weaponData.averages);
    var rg = accuracyValue(flattened[game_id], "rg");
    var rgTT = accuracyTooltip("rg", rg, weaponData.averages); 
    var pg = accuracyValue(flattened[game_id], "pg");
    var pgTT = accuracyTooltip("pg", pg, weaponData.averages); 
    var hmg = accuracyValue(flattened[game_id], "hmg");
    var hmgTT = accuracyTooltip("hmg", hmg, weaponData.averages); 
    var bfg = accuracyValue(flattened[game_id], "bfg");
    var bfgTT = accuracyTooltip("bfg", bfg, weaponData.averages); 

    data.addRow([game_id.toString(), 0, "", mg, mgTT, sg, sgTT, gl, glTT, rl,
            rlTT, lg, lgTT, rg, rgTT, pg, pgTT, hmg, hmgTT, bfg, bfgTT]);
  }

  var options = getOptions(false);
  options.lineWidth=2;


  var chart = new google.visualization.LineChart(document.getElementById('accuracyChart'));

  // a click on a point sends you to that games' page
  var accuracySelectHandler = function(e) {
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
    series: {
      0: { color: weaponColors["gt"] },
      1: { color: weaponColors["mg"] },
      2: { color: weaponColors["sg"] },
      3: { color: weaponColors["gl"] },
      4: { color: weaponColors["rl"] },
      5: { color: weaponColors["lg"] },
      6: { color: weaponColors["rg"] },
      7: { color: weaponColors["pg"] },
      8: { color: weaponColors["hmg"] },
      9: { color: weaponColors["bfg"] }
    }
  };
}

// Calculate the damage Y value for a given weapon stat
function damageValue(gameWeaponStats, weapon) {
  if (gameWeaponStats[weapon] == undefined) {
    return null;
  }
  return gameWeaponStats[weapon].frags;
}

// Calculate the damage tooltip text for a given weapon stat
function damageTooltip(weapon, dmg) {
  if (dmg == null) {
    return null;
  }
  return weapon.toUpperCase() + ": " + Math.round(dmg).toString() + "% of kills";
}

// Draw the damage chart into the "damageChart" div id
function drawDamageChart(weaponData) {

  var data = new google.visualization.DataTable();
  data.addColumn('string', 'X');
  data.addColumn('number', 'GT');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'MG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'SG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'GL');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'RL');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'LG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'RG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'PG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'HMG');
  data.addColumn({type: 'string', role: 'tooltip'});
  data.addColumn('number', 'BFG');
  data.addColumn({type: 'string', role: 'tooltip'});

  var flattened = flatten(weaponData);

  for(i in weaponData.games) {
    var game_id = weaponData.games[i];

    var totalFrags = 0;
	for (var w in flattened[game_id]) {
	  var frags = parseInt(flattened[game_id][w].frags) || 0;
	  totalFrags += frags;
	}
	if (totalFrags == 0)
	  totalFrags = 1;
    totalFrags /= 100.0;
	
    var gt = damageValue(flattened[game_id], "gt") / totalFrags;
    var gtTT = damageTooltip("gt", gt, weaponData.averages); 
    var mg = damageValue(flattened[game_id], "mg") / totalFrags;
    var mgTT = damageTooltip("mg", mg, weaponData.averages); 
    var sg = damageValue(flattened[game_id], "sg") / totalFrags;
    var sgTT = damageTooltip("sg", sg, weaponData.averages);
    var gl = damageValue(flattened[game_id], "gl") / totalFrags;
    var glTT = damageTooltip("gl", gl, weaponData.averages);
    var rl = damageValue(flattened[game_id], "rl") / totalFrags;
    var rlTT = damageTooltip("rl", rl, weaponData.averages);
    var lg = damageValue(flattened[game_id], "lg") / totalFrags;
    var lgTT = damageTooltip("lg", lg, weaponData.averages);
    var rg = damageValue(flattened[game_id], "rg") / totalFrags;
    var rgTT = damageTooltip("rg", rg, weaponData.averages); 
    var pg = damageValue(flattened[game_id], "pg") / totalFrags;
    var pgTT = damageTooltip("pg", pg, weaponData.averages); 
    var hmg = damageValue(flattened[game_id], "hmg") / totalFrags;
    var hmgTT = damageTooltip("hmg", hmg, weaponData.averages); 
    var bfg = damageValue(flattened[game_id], "bfg") / totalFrags;
    var bfgTT = damageTooltip("bfg", bfg, weaponData.averages); 

    data.addRow([game_id.toString(), gt, gtTT, mg, mgTT, sg, sgTT, gl, glTT, rl,
            rlTT, lg, lgTT, rg, rgTT, pg, pgTT, hmg, hmgTT, bfg, bfgTT]);
  }

  var options = getOptions(true);
  options.legend.maxLines = 3;
  options.isStacked = true;
  
  var chart = new google.visualization.ColumnChart(document.getElementById('damageChart'));

  // a click on a point sends you to that game's page
  var damageSelectHandler = function(e) {
    var selection = chart.getSelection()[0];
    if (selection != null && selection.row != null) {
      var game_id = data.getFormattedValue(selection.row, 0);
      window.location.href = "/game/" + game_id.toString();
    }
  };
  google.visualization.events.addListener(chart, 'select', damageSelectHandler);

  chart.draw(data, options);
}
