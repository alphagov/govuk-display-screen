(function(){
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.matrix === 'undefined'){ root.matrix = {} }

  var search = {
    terms: [],
    newTerms: [],
    $el: false,
    nextRefresh: 0,

    endpoint: function(){
      return "/live-searches"; // Adjust endpoint if needed
    },

    safeTerm: function(term){
      // Validate the term, similar logic as before
      if(term.indexOf('@') > -1){
        return false;
      }
      if(term.indexOf('<script>') > -1){
        return false;
      }
      if(term.match(/^[0-9\s]+$/)){
        return false;
      }
      if(term.match(/^[A-Za-z]{2}\s?[0-9]{2}\s?[0-9]{2}\s?[0-9]{2}\s?[A-Za-z]$/)){
        return false;
      }
      if(term === "Sorry, we are experiencing technical difficulties (503 error)"){
        return false;
      }
      //Sometimes the API returns '(other)' results which skew the data:
      //https://support.google.com/analytics/answer/9309767#zippy=%2Cin-this-article.
      //It doesn't look like we can eliminate them using the API query itself.
      //There are only max 10 results, so a Ruby check has been added to eliminate (other) results.
      if(term === "(other)") {
        return false;
      }
      return true;
    },

    addTerm: function(term, count){
      var i, _i;
      for(i=0, _i=search.terms.length; i<_i;  i++){
        if(search.terms[i].term === term){
          search.terms[i].nextTick = count;
          return true;
        }
      }
      search.terms.push({
        term: term,
        total: 0,
        nextTick: count,
        currentTick: 0,
      });
    },

    zeroNextTicks: function(){
      var i, _i;
      for(i=0, _i=search.terms.length; i<_i;  i++){
        search.terms[i].nextTick = 0;
      }
    },

    addNextTickValues: function(data){
      var i, _i, term, activeUserCount;
      for(i=0, _i=data.length; i<_i; i++){
        term = data[i].page_slug;
        activeUserCount = root.parseInt(data[i].active_users_count, 10);

        // Only add valid terms
        if(term !== 'Search' && search.safeTerm(term)){
          search.addTerm(term, activeUserCount);
        }
      }
    },

    addTimeIndexValues: function(){
      var i, _i, j, _j, term, newPeople, nonZeroTerms = [];
      for(i=0, _i=search.terms.length; i<_i;  i++){
        term = search.terms[i];
        newPeople = term.currentTick < term.nextTick ? term.nextTick - term.currentTick : 0;
        term.total = term.total + newPeople;
        term.currentTick = term.nextTick;
        if(newPeople > 0){
          for(j=0, _j=newPeople; j<_j; j++){
            search.newTerms.push(term.term);
          }
        }
        if(term.currentTick > 0){
          nonZeroTerms.push(term);
        }
      }
      search.newTerms.sort(function(){ return Math.floor((Math.random() * 3) - 1); });
      search.terms = nonZeroTerms;
    },

    parseResponse: function(data){
      search.zeroNextTicks();
      search.addNextTickValues(data);
      search.addTimeIndexValues();
    },

    displayResults: function(){
      var term = search.newTerms.pop();
      if(term){
        var updateElement = search.updateElement();
        updateElement.prepend('<li class="govuk-body-l">'+$('<div class="govuk-body-l">').text(term).html()+'</li>');
        updateElement.css('margin-top',-search.$el.find('li').first().outerHeight(true)).animate({'margin-top':0}, function(){
          search.$el.find('li:gt(20)').remove();
          root.setTimeout(search.displayResults, (search.nextRefresh - Date.now()) / search.newTerms.length);
        });
      } else {
        root.setTimeout(search.displayResults, 5e3);
      }
    },

    init: function(){
      search.$el = $('#search');

      search.reload();
      search.displayResults();
      window.setInterval(search.reload, 60e3);
    },

    reload: function(){
      var endpoint = search.endpoint();

      search.nextRefresh = Date.now() + 60e3;
      $.ajax({ dataType: 'json', url: endpoint, success: search.parseResponse });
    },

    updateElement: function(){
      return search.$el;
    },
  };

  root.matrix.search = search;
}).call(this);