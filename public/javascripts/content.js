(function(){
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.matrix === 'undefined'){ root.matrix = {} }

  var content = {
    pages: [],
    $el: false,

    endpoint: function(){
      // return "/get-content";
    },
    parseResponse: function(data){
      content.pages = [];
      // content.pages.push ({
      //   title: data["page_title"],
      //   displayHits: data["page_views"],
      //   percentageUp: data["percent_change"]
      // });

       content.pages.push({
        title: "title",
        displayHits: "10",
        percentageUp: "5"
      });
    
      
      content.displayResults();
    },  
    displayResults: function(){
      matrix.template(content.$el, 'content-results', { pages: content.pages });
    },
    init: function(){
      console.log('content')
      content.$el = $('#content');

      content.reload();
      window.setInterval(content.reload, 30); // refresh every 3 hours
    },
    reload: function(){
      // console.log('content')
      var endpoint = content.endpoint();

      $.ajax({ dataType: 'json', url: endpoint, success: content.parseResponse});
    }
  };

  root.matrix.content = content;
}).call(this);
