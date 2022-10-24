require 'google/apis/analyticsreporting_v4'
require 'date'
require 'json'

class Content
  attr_reader :service, :credentials
  def initialize 
    @service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    @credentials = Google::Auth::ServiceAccountCredentials.make_creds(
      scope: "https://www.googleapis.com/auth/analytics.readonly"
    )
    @service.authorization = @credentials 
  end

  def get_content
     #["WEEK ONE", week_one_responses, "WEEK TWO", week_two_responses]
    #   results = []
    #   week_one_responses.each do |week_one|
    #     match = week_two_responses.select {|n| n[:page_path] == week_one[:page_path] && n[:page_title] == week_one[:page_title]}
    #     unless match[0].nil?
    #       results << percentage_change(week_one, match[0]) 
    #     end  
    #   end
    #  results
    # results = {:page_title=>"Bem-vindo ao GOV.UK", :page_views=>167.0, :percent_change=>-12.105263157894736}, {:page_title=>"Bem-vindos ao GOV.UK", :page_views=>6.0, :percent_change=>-50.0}, {:page_title=>"Benvenuti in GOV.UK", :page_views=>8.0, :percent_change=>100.0}, {:page_title=>"Benvenuto in GOV.UK", :page_views=>1.0, :percent_change=>0.0}, {:page_title=>"Benvenuto su GOV.UK", :page_views=>57.0, :percent_change=>5.555555555555555}, {:page_title=>"Bienvenido a GOV.UK", :page_views=>334.0, :percent_change=>71.28205128205128}, {:page_title=>"Bienvenue chez GOV.UK", :page_views=>10.0, :percent_change=>233.33333333333334}, {:page_title=>"Bienvenue sur GOV.FR", :page_views=>120.0, :percent_change=>27.659574468085108}, {:page_title=>"Bienvenue sur GOV.UK", :page_views=>5.0, :percent_change=>-66.66666666666666}, {:page_title=>"Bun venit la GOV.UK", :page_views=>270.0, :percent_change=>-14.285714285714285}, {:page_title=>"Chào mừng đến với GOV.UK", :page_views=>6.0, :percent_change=>-14.285714285714285}, {:page_title=>"GOV.UK saytiga xush kelibsiz", :page_views=>1.0, :percent_change=>-66.66666666666666}, {:page_title=>"GOV.UK şehrine hoş geldiniz", :page_views=>5.0, :percent_change=>25.0}, {:page_title=>"GOV.UK میں خوش آمدید", :page_views=>1.0, :percent_change=>0.0}, {:page_title=>"GOV.UK में आपका स्वागत है", :page_views=>1.0, :percent_change=>-80.0}, {:page_title=>"GOV.UK ਵਿੱਚ ਤੁਹਾਡਾ ਸੁਆਗਤ ਹੈ", :page_views=>1.0, :percent_change=>0.0}, {:page_title=>"GOV.UK へようこそ", :page_views=>3.0, :percent_change=>0.0}, {:page_title=>"GOV.UK'a hoş geldiniz", :page_views=>127.0, :percent_change=>-8.633093525179856}, {:page_title=>"GOV.UK'ye hoş geldiniz", :page_views=>2.0, :percent_change=>100.0}, {:page_title=>"GOV.UK에 오신 것을 환영합니다.", :page_views=>4.0, :percent_change=>33.33333333333333}, {:page_title=>"GOV.UKへようこそ", :page_views=>14.0, :percent_change=>40.0}, {:page_title=>"Hoşgeldiniz GOV.UK", :page_views=>1.0, :percent_change=>0.0}, {:page_title=>"Laipni lūdzam GOV.UK", :page_views=>3.0, :percent_change=>0.0}, {:page_title=>"Mirë se vini në GOV.UK", :page_views=>6.0, :percent_change=>500.0}, {:page_title=>"Selamat datang di GOV.UK", :page_views=>3.0, :percent_change=>0.0}, {:page_title=>"Sveiki atvykę į GOV.UK", :page_views=>15.0, :percent_change=>25.0}, {:page_title=>"Üdvözöljük a GOV.UK oldalán", :page_views=>26.0, :percent_change=>-13.333333333333334}, {:page_title=>"Välkommen till GOV.UK", :page_views=>6.0, :percent_change=>-25.0}, {:page_title=>"Vitajte na GOV.UK", :page_views=>8.0, :percent_change=>-11.11111111111111}, {:page_title=>"Vitajte na stránke GOV.UK", :page_views=>12.0, :percent_change=>9.090909090909092}, {:page_title=>"Vítejte na GOV.UK", :page_views=>31.0, :percent_change=>-16.216216216216218}, {:page_title=>"Vítejte v GOV.UK", :page_views=>9.0, :percent_change=>200.0}, {:page_title=>"​​Welcome to GOV.UK", :page_views=>2.0, :percent_change=>100.0}, {:page_title=>"​Welcome to GOV.UK", :page_views=>3.0, :percent_change=>-25.0}, {:page_title=>"Welcome to GOV.UK", :page_views=>1568498.0, :percent_change=>-9.950833149617871}, {:page_title=>"Welkom bij GOV.UK", :page_views=>6.0, :percent_change=>-33.33333333333333}, {:page_title=>"Willkommen bei GOV.UK", :page_views=>37.0, :percent_change=>-5.128205128205128}, {:page_title=>"Witamy w GOV.UK", :page_views=>192.0, :percent_change=>-18.29787234042553}, {:page_title=>"Καλώς ήρθατε στο GOV.UK", :page_views=>17.0, :percent_change=>-15.0}, {:page_title=>"Добре дошли в GOV.UK", :page_views=>81.0, :percent_change=>-3.571428571428571}, {:page_title=>"Добро пожаловать в GOV.UK", :page_views=>62.0, :percent_change=>0.0}, {:page_title=>"Добро пожаловать на GOV.RU", :page_views=>294.0, :percent_change=>-9.538461538461538}, {:page_title=>"Ласкаво просимо до GOV.UK", :page_views=>121.0, :percent_change=>-4.724409448818897}, {:page_title=>"به GOV.UK خوش آمدید", :page_views=>14.0, :percent_change=>55.55555555555556}, {:page_title=>"مرحبًا بك في GOV.UK", :page_views=>67.0, :percent_change=>-30.208333333333332}, {:page_title=>"ยินดีต้อนรับสู่ GOV.UK", :page_views=>6.0, :percent_change=>200.0}, {:page_title=>"欢迎来到 GOV.UK", :page_views=>232.0, :percent_change=>-19.72318339100346}, {:page_title=>"欢迎来到GOV.UK", :page_views=>35.0, :percent_change=>16.666666666666664}, {:page_title=>"欢迎访问GOV.UK", :page_views=>2.0, :percent_change=>100.0}, {:page_title=>"歡迎來到 GOV.UK", :page_views=>25.0, :percent_change=>-19.35483870967742}, {:page_title=>"歡迎來到GOV.UK", :page_views=>2.0, :percent_change=>100.0}

    results = {page_title: "Hi", page_views: 167.0, percent_change: 12.105263157894736}
    results = [
      {page_title: "Hi", page_views: 167.0, percent_change: 12.105263157894736},
      {page_title: "Hii", page_views: 168.0, percent_change: 14.105263157894736},
      {page_title: "Hiiiii", page_views: 197.0, percent_change: 16.105263157894736},
      {page_title: "Hiiiiiiiii", page_views: 19.0, percent_change: 19.105263157894736},
    ]
    results.to_json
  end

  def percentage_change(week_one_hits, week_two_hits)
    numerator = week_two_hits[:page_views].to_f - week_one_hits[:page_views].to_f
    denominator = week_one_hits[:page_views].to_f

    percent_change = (numerator / denominator) * 100

    {
      page_title: week_two_hits[:page_title],
      page_views: week_two_hits[:page_views].to_f,
      percent_change: percent_change
    }
  end

  def analytics_reports(date_start, date_end)
    Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      { report_requests: [build(date_start, date_end)] }
    )
  end

  def week_one_responses
    week_one_request = service.batch_get_reports(week_one)
    week_one_response = week_one_request.reports.first.to_h
  
    page_data = []
        week_one_response[:data][:rows].each do |row|
        row_data = {
          page_views: row[:metrics][0][:values][0],
          page_path: row[:dimensions][0],
          page_title: row[:dimensions][1]
        }
        page_data << row_data unless row_data[:page_title] == "Page not found - GOV.UK"
      end
    page_data
  end

  def week_two_responses
    week_two_request = service.batch_get_reports(week_two)
    week_two_response = week_two_request.reports.first.to_h

    page_data = []
        week_two_response[:data][:rows].each do |row|
        row_data = {
          page_views: row[:metrics][0][:values][0],
          page_path: row[:dimensions][0],
          page_title: row[:dimensions][1]
        }
        page_data << row_data unless row_data[:page_title] == "Page not found - GOV.UK"
      end
    page_data
  end

  def week_one
    date_start = Date.today - 13
    date_end = Date.today - 7

    analytics_reports(date_start, date_end)
  end

  def week_two
    date_start = Date.today - 6
    date_end = Date.today

    analytics_reports(date_start, date_end)
  end

  private

  def build(date_start, date_end)
    Google::Apis::AnalyticsreportingV4::ReportRequest.new(
      view_id: 'ga:53872948',
      sampling_level: 'LARGE',
      date_ranges: [date_range(date_start, date_end)],
      metrics: [metric],
      dimensions: [dimension_path, dimension_title],
      filters: ["pagePath!~^(/$|/(.*-finished$|\\?backtoPage|transformation|service-manual|performance|government|search|done|print|help).*);ga:pageTitle!~(3[0-9]{2} |4[0-9]{2} |5[0-9]{2} |An error has occurred)"],
      page_size: "200"
    )
  end

  def date_range(date_start, date_end)
    Google::Apis::AnalyticsreportingV4::DateRange.new(
      start_date: date_start.to_s,
      end_date: date_end.to_s
    )
  end

  # Set the metric
  def metric
    Google::Apis::AnalyticsreportingV4::Metric.new(
      expression: "ga:pageviews"
    )
  end

  #Set the pagePath dimension
  def dimension_path
    Google::Apis::AnalyticsreportingV4::Dimension.new(
      name: "ga:pagePath"
    )
  end

  #Set the pageTitle dimension
  def dimension_title
    Google::Apis::AnalyticsreportingV4::Dimension.new(
      name: "ga:pageTitle"
    )
  end
end