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
    #  week_one_responses.to_json
    [
      { page_title: "Mr W Turvill v Imperial Blue Ltd: 1401730/2021", page_views: "1"},
      { page_title: "Building on history, sending agents into the future - rangeland modelling, retrospect and prospect.", page_views: "2"},
      { page_title: "Mr R Bentley v Enterprise Support Services UK Ltd: 3319865/2019", page_views: "3"},
      { page_title: "NATS licence changes: UK-Ireland functional airspace block performance plan", page_views: "4"},
      { page_title: "NDTMS annual reports and methodology: proposed changes", page_views: "5"},
      { page_title: "Mr W Turvill v Imperial Blue Ltd: 1401730/2021", page_views: "1"},
      { page_title: "Building on history, sending agents into the future - rangeland modelling, retrospect and prospect.", page_views: "2"},
      { page_title: "Mr R Bentley v Enterprise Support Services UK Ltd: 3319865/2019", page_views: "3"},
      { page_title: "NATS licence changes: UK-Ireland functional airspace block performance plan", page_views: "4"},
      { page_title: "NDTMS annual reports and methodology: proposed changes", page_views: "5"},
    ].to_json
  end

  def analytics_reports(date_start, date_end)
    Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      { report_requests: [build(date_start, date_end)] }
    )
  end

  def week_one_responses
    week_one_request = service.batch_get_reports(last_seven_days)
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


  def last_seven_days
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
      sort: '-ga:pageviews',
      dimensions: [dimension_path, dimension_title],
      filters: ["pagePath!~^(/$|/(.*-finished$|\\?backtoPage|transformation|service-manual|performance|government|search|done|print|help).*);ga:pageTitle!~(3[0-9]{2} |4[0-9]{2} |5[0-9]{2} |An error has occurred)"],
      page_size: '10'
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