var weaponStats, weaponCols; // arrays generated in accuracy.mako

function showStats(info) {
  switch (info) {
    case "all":
      showWeaponStats('<div>Kills / Acc</div><div style="font-size:x-small; color:#888">Hits / Shots</div>', getWeaponSummary);
      break;
    case "acc":
      showWeaponStats("", getWeaponValue, "acc", getMaxColumnValue("acc"), "%");
      break;
    case "kills":
      showWeaponStats("", getWeaponValue, "kills", getMaxColumnValue("kills"));
      break;
    case "hits":
      showWeaponStats("", getWeaponValue, "hits", getMaxColumnValue("hits"));
      break;
    case "shots":
      showWeaponStats("", getWeaponValue, "fired", getMaxColumnValue("fired"));
      break;
  }  
}

function showWeaponStats(legend, contentProvider, field, maxVals, suffix) {
  for (var i = 0; i<weaponStats.length; i++) {
    var cells = $($("#accuracyTable tbody tr")[i]).children();
    $(cells[1]).html(legend);

    for (var j = 0; j<weaponCols.length; j++) {
      var $cell = $(cells[j + 2]);
      var data = weaponStats[i][weaponCols[j]];
      $cell.html(contentProvider(data, i, j, field, maxVals, suffix || ""));
    }
  }
}

function getWeaponSummary(data) {
  if (!data || !data.kills && !data.fired && !data.hits)
    return "";
  var html = "<div>" + data.kills + " / " + data.acc + "%</div>";
  html += '<div style="font-size:x-small; color:#888">' + data.hits + " / " + data.fired + '</div>';
  return html;
}

function getWeaponValue(data, i, j, field, maxVals, suffix) {
  var val = data[field];
  if (!val) return "";
  if (val == maxVals[j])
    return "<span style='color:yellow'>" + val + suffix + "</span>";
  return val + suffix;
}

function getMaxColumnValue(field) {
  var maxColVal = [];
  weaponCols.forEach(function(w, i) {
    for (var j = 0; j < weaponStats.length; j++) {
      maxColVal[i] = Math.max(maxColVal[i] || 0, weaponStats[j][w][field]);
    }
  });
  return maxColVal;
}



$("#chartRow h3").click(function() {
  $("#chartRow h3").removeClass("selected");
  $(this).addClass("selected");
  showStats($(this).data("info"));
});

showStats("all");