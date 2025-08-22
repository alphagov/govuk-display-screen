(function(){
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.matrix === 'undefined'){ root.matrix = {} }

  var traffic = {
    $el: false,
    user_count: 0,

    endpoint: function(){
      return "/active-users";
    },
    
    parseResponse: function(data){
      console.warn(data)
      traffic.user_count = data.active_users_30_minutes
      traffic.displayResults() 
    },
    displayResults: function(){
      traffic.$el.text(root.matrix.numberWithCommas(traffic.user_count))
    },
    init: function(){
      traffic.$el = $('#traffic-count');

      traffic.reload();
      window.setInterval(traffic.reload, 30e3);
    },
    reload: function(){
      var endpoint = traffic.endpoint();

      $.ajax({ dataType: 'json', url: endpoint, success: traffic.parseResponse});
    }
  };

  root.matrix.traffic = traffic;
}).call(this);
