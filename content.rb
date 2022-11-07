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

  def most_popular_govuk_pages
    format_response.to_json
  end

private

  def google_analytics_request
    service.batch_get_reports(analytics_reports)
  end

  def analytics_reports
    Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      { report_requests: [build_google_analytics_query] }
    )
  end

  def format_response
    begin
      ga_response = google_analytics_request.reports.first.to_h
    rescue Google::Apis::Error => e
      puts "#{e.message}"
      page_data = [
        {
          page_views: "No data available",
          page_path: "",
          page_title: "No data available"
        }
      ]
    else
      page_data = []
        ga_response[:data][:rows].each do |row|
          row_data = {
            page_views: format_page_views_with_commas(row[:metrics][0][:values][0]),
            page_path: row[:dimensions][0],
            page_title: row[:dimensions][1]
          }
          page_data << row_data
        end
      page_data
    end
  end

  def format_page_views_with_commas(page_views)
    page_views.reverse.chars.each_slice(3).map(&:join).join(',').reverse
  end

  def build_google_analytics_query
    Google::Apis::AnalyticsreportingV4::ReportRequest.new(
      view_id: 'ga:53872948',
      sampling_level: 'LARGE',
      date_ranges: [set_date_range],
      metrics: [set_metric],
      order_bys: [{field_name: 'ga:pageviews', sort_order: 'DESCENDING'}],
      dimensions: [set_dimension_path, set_dimension_title],
      page_size: '10'
    )
  end

  def set_date_range
    start_date = Date.today - 6
    end_date = Date.today

    Google::Apis::AnalyticsreportingV4::DateRange.new(
      start_date: start_date.to_s,
      end_date: end_date.to_s
    )
  end

  def set_metric
    Google::Apis::AnalyticsreportingV4::Metric.new(
      expression: "ga:pageviews"
    )
  end

  def set_dimension_path
    Google::Apis::AnalyticsreportingV4::Dimension.new(
      name: "ga:pagePath"
    )
  end

  def set_dimension_title
    Google::Apis::AnalyticsreportingV4::Dimension.new(
      name: "ga:pageTitle"
    )
  end
end
