(function(){
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.matrix === 'undefined'){ root.matrix = {} }

  var trafficYesterday = {
    $el: false,
    user_count: 0,

    endpoint: function(){
      return "/active-users-yesterday";
    },
    
    parseResponse: function(data){
      console.warn(data)
      trafficYesterday.user_count = data
      trafficYesterday.displayResults() 
    },
    displayResults: function(){
      trafficYesterday.$el.text(root.matrix.numberWithCommas(trafficYesterday.user_count))
    },
    init: function(){
      trafficYesterday.$el = $('#traffic-count-yesterday');

      trafficYesterday.reload();
      // window.setInterval(trafficYesterday.reload, 30e3);
    },
    reload: function(){
      var endpoint = trafficYesterday.endpoint();

      $.ajax({ dataType: 'json', url: endpoint, success: trafficYesterday.parseResponse});
    }
  };

  root.matrix.trafficYesterday = trafficYesterday;
}).call(this);
