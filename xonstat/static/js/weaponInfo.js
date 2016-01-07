var tableId = "#accuracyTable";

function main(data, container, show_weapon_kills) {
  var wpns = ['gt', 'mg', 'sg', 'gl', 'rl', 'lg', 'rg', 'pg', 'hmg', 'bfg', 'cg', 'ng', 'pm', 'gh'];
  container.append($(document.createElement('table')).prop({
    'id': tableId.substring(1),
    'class': 'table table-hover table-condensed',
    'style': 'margin-bottom:5px'
  }));
  $(tableId).append(document.createElement('colgroup'));
  $(tableId).append(document.createElement('thead'));
  $(tableId + ' thead').append(document.createElement('tr'));
  $(tableId).append(document.createElement('tbody'));
  
  data.weaponFired.gt = true;
  
  
  $(tableId + ' colgroup').append('<col style="min-width:150px">');
  $(tableId + ' thead tr').append('<th></th>');
  
  // making headers
  wpns.forEach(function(item) {
    if (data.weaponFired[item]) {
      $(tableId + ' colgroup').append('<col width="80px" style="min-width:80px">');
      $(tableId + ' thead tr').append('<th style="padding: 4px 5px;"><img src="/static/images/24x24/' + item + '.png" alt="' + data.weapons[item].name + '" style="width:24px; height:24px;">' + item.toUpperCase() + '</th>');
    }
  });
  
  // apending weapons stats
  data.pgstats.forEach(function(item) {
    var row = $(document.createElement('tr'));
    var player_weapon_stats = data.pwstats[item.player_id.toString()];
    
    row.append('<td><a href="/player/' + item.player_id.toString() + '"><span style="color: white">' + player_weapon_stats.nick + '</span></a></td>');
    wpns.forEach(function(wpn) {
      if (data.weaponFired[wpn])
        if (show_weapon_kills) {
          if (player_weapon_stats.weapons[wpn][0] != 0)
            row.append('<td class="weapon_'  + wpn + '">' + player_weapon_stats.weapons[wpn][0] + '</td>');
          else
            row.append('<td></td>');
        } else {
          if (player_weapon_stats.weapons[wpn][2] != 0) {
            var acc = player_weapon_stats.weapons[wpn][2] / player_weapon_stats.weapons[wpn][3] * 100;
            row.append('<td class="weapon_'  + wpn + '">' + Math.floor(acc) + '%</td>');
          } else
            row.append('<td></td>');
        }
    });
    
    $(tableId + ' tbody').append(row);
    
  });
  
  // making max values bold and underlined
  wpns.forEach(function(wpn) {
    var maxItems = [];
    var max = 0;
    $(tableId + ' td.weapon_' + wpn).each(function() {
      var item = $(this);
      var item_value = parseInt(item.html());
      if ( (max == 0) || (item_value > max) ) {
        maxItems = [item];
        max = item_value;
      } else if (item_value == max) {
        maxItems.push(item);
      }
    });
    
    maxItems.forEach(function (item) {
      item.css({
        'font-weight': 'bold',
        'text-decoration': 'underline'
      });
    });
  });
}

$(document).ready(function() {
  var gamedata;
  var main_container = $(tableId).parent().parent();
  var table_container;
  main_container.empty();
  $.get(window.location.href + '.json', function (data) {
    main_container.append("<h3>Weapon Info</h3>");
    main_container.append(
    $(document.createElement('a'))
      .prop('href', 'javascript:void(0)')
      .html("Accuracy")
      .on('click', function() {
        $(tableId).remove();
        main(gamedata, table_container, 0); 
      })
    );
    main_container.append("<span> | </span>");
    main_container.append(
    $(document.createElement('a'))
      .prop('href', 'javascript:void(0)')
      .html("Frags")
      .on('click', function() {
        $(tableId).remove();
        main(gamedata, table_container, 1); 
      })
    );
    main_container.append('<div style="width:100%;overflow-x:auto">');
    table_container = main_container.find("div");
    
    gamedata = data;
    main(gamedata, table_container, 0);
  });
});
