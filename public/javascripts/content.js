(function(){
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.matrix === 'undefined'){ root.matrix = {} }

  var content = {
    pages: [],
    $el: false,

    endpoint: function(){
      return "/get-content";
    },
    parseResponse: function(data){
      content.pages = [];
      for (let i = 0; i < data.length; i++) {
        content.pages.push ({
          title: data[i]["page_title"],
          displayHits: data[i]["page_views"],
        });
      }
      
      content.displayResults();
    },  
    displayResults: function(){
      matrix.template(content.$el, 'content-results', { pages: content.pages.slice(0,10) });
    },
    init: function(){
      content.$el = $('#content');

      content.reload();
      window.setInterval(content.reload, 5000);
    },
    reload: function(){
      var endpoint = content.endpoint();

      $.ajax({ dataType: 'json', url: endpoint, success: content.parseResponse});
    }
  };

  root.matrix.content = content;
}).call(this);
