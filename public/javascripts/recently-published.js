(function(){
    "use strict"
    var root = this,
        $ = root.jQuery;
    if(typeof root.matrix === 'undefined'){ root.matrix = {} }
  
    var recentlyPublished = {
      $el: false,
      posts: [],
  
      addNewPage: function(page){
        var i, _i, time;
        for(i=0,_i=recentlyPublished.posts.length; i<_i; i++){
          if(page.id === recentlyPublished.posts[i].id){
            return;
          }
        }
        time = stamp.fromISOString(page.updated);
        if(time.getTime() > Date.now()){
          return;
        }
        recentlyPublished.posts.push({
          id: page.id,
          type: page.title.split(': ')[0],
          title: page.title.split(': ').slice(1).join(': '),
          published: page.updated,
          date: time
        });
      },
      addNewPosts: function(data){
        var i, _i;
        for(i=0,_i=data.feed.entry.length; i<_i; i++){
          recentlyPublished.addNewPage(data.feed.entry[i]);
        }
      },
      parseResponse: function(data){
        recentlyPublished.addNewPosts(data);
        recentlyPublished.displayResults();
      },
      displayResults: function(){
        console.log("Displaying")
        recentlyPublished.posts.sort(function(a,b){ return b.date - a.date; });
        matrix.template(recentlyPublished.$el, 'recently-published-template', { posts: recentlyPublished.posts.slice(0,10) });
        console.log({"recentlyPublished.posts.slice(0,10)": recentlyPublished.posts.slice(0,10)})
        recentlyPublished.$el.find("span").prettyDate();
      },
      init: function(){
        console.log("Initializing")
        recentlyPublished.$el = $('#recently-published');
        recentlyPublished.reload();
        window.setInterval(recentlyPublished.reload, 60e3);
  
        window.setInterval(function(){ recentlyPublished.$el.find("span").prettyDate(); }, 5e3);
      },
      reload: function(){
        console.log("Reloading")
        $.ajax({
          dataType: 'json',
          url: '/recently-published',
          success: recentlyPublished.parseResponse
        });
      }
    };
  
    root.matrix.recentlyPublished = recentlyPublished;
  }).call(this);
  