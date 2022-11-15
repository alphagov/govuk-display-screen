(function(){
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.matrix === 'undefined'){ root.matrix = {} }

  var traffic_report = {
    $el: false,
    visits_per_hour: [],

    endpoint: function(){
      return "/traffic-report";
    },

    parseResponse: function(data){
      traffic_report.visits_per_hour = data
      traffic_report.displayResults() 
    },
    displayResults: function(){
      matrix.template(traffic_report.$el, 'traffic-count-graph', {visits_per_hour:  root.matrix.traffic_report.visits_per_hour} );
      traffic_report.createChart();
    },
    init: function(){
      const ctx = document.getElementById('traffic-count-graph').getContext('2d')
      traffic_report.$el = $(ctx);
      traffic_report.reload();
      window.setInterval(traffic_report.reload, 60e3 * 60 * 24);
    },
    reload: function(){
      var endpoint = traffic_report.endpoint();

      $.ajax({ dataType: 'json', url: endpoint, success: traffic_report.parseResponse});
    },
    createData: function(){
      console.log(traffic_report.visits_per_hour)
      const data = []
      const labels = []
      for( var i = 0; i < traffic_report.visits_per_hour.length; i++ ){
        if( traffic_report.visits_per_hour[i].hour != "total_visitors_24_hours"){
          labels.push(traffic_report.visits_per_hour[i].hour)
          data.push(traffic_report.visits_per_hour[i].visits)
         }
      }

      const dataset = {
        labels: traffic_report.formatHours(labels),
        datasets: [{
          fill: 'start',
          data: data.reverse(),
          backgroundColor: 'rgb(37, 93, 160)',
          color: 'rgb(243, 242, 241)',
          borderColor: 'rgb(83, 88, 95)'
        }]
      }   
      console.log(dataset)
      return dataset;   
    },
    createChart: function(){
      const chart = new Chart(traffic_report.$el, {
        type: 'line',
        data: traffic_report.createData(),
        options: {
          scales: {
            y: {
              beginAtZero: false,
              ticks: {
                color: 'rgb(83, 88, 95)'
              },
              grid: {
                color: 'rgba(83, 88, 95, 0.2)'
              }
            },
            x: {
              ticks: {
                color: 'rgb(83, 88, 95)'
              },
              grid: {
                color: 'rgba(83, 88, 95, 0.2)'
              }
            }
          },
          plugins: {
            legend: {
              display: false
            },
            title: {
              text: 'People on GOV.UK over the last 24 hours',
              font: {
                size: '18'
              },
              display: true,
              color: 'black'
            }
          }
        }
      })
    },
    formatHours: function(hours) {
      var orderedHours = hours.reverse()
      var formattedHours = []
      
      for (var i = 0; i < orderedHours.length; i++) {
        var num = ""
        if (orderedHours[i].toString().length == 1) {
          num = "0" + orderedHours[i]
        } else {
          num = orderedHours[i]
        }
        formattedHours.push(num + ":00")
      }
      return formattedHours
    }
  };

  root.matrix.traffic_report = traffic_report;
}).call(this);

