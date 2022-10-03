require 'google/apis/analyticsreporting_v4'
require 'date'

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
     ["WEEK ONE", week_one_responses, "WEEK TWO", week_two_responses]
  end

  def analytics_reports(date_start, date_end)
    Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      { report_requests: [build(date_start, date_end)] }
    )
  end

  def week_one_responses
    week_one_request = service.batch_get_reports(week_one)
    week_one_response = week_one_request.reports.first.to_h
    # week_one_response
    page_data = []
        week_one_response[:data][:rows].each do |row|
        row_data = {
          page_views: row[:metrics][0][:values][0],
          page_path: row[:dimensions][0],
          page_title: row[:dimensions][1]
        }
        page_data << row_data
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
        page_data << row_data
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
      page_size: "20"
    )
  end

  def date_range(date_start, date_end)
    date_today = Date.today
    date_two_weeks_ago = date_today - 14
    Google::Apis::AnalyticsreportingV4::DateRange.new(
      start_date: date_two_weeks_ago.to_s,
      end_date: date_today.to_s
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