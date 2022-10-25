require 'googleauth'
require 'google/apis/analyticsreporting_v4'

class Content 
  def get_content
    date_from = Date.today -1
    date_to = Date.today
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    credentials = Google::Auth::ServiceAccountCredentials.make_creds(scope: "https://www.googleapis.com/auth/analytics.readonly")
    analytics.authorization = credentials 
    view_id = 'ga:53872948'
    dimension = Google::Apis::AnalyticsreportingV4::Dimension.new(name: "ga:browser")
    date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: date_from.strftime('%Y-%m-%d'), end_date: date_to.strftime('%Y-%m-%d'))
    metric = Google::Apis::AnalyticsreportingV4::Metric.new(expression: 'ga:users')

    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
        view_id: view_id,
        metrics: [metric],
        dimensions: [dimension],
        date_ranges: [date_range]
      )]
    )

    response = analytics.batch_get_reports(request)
    json = JSON.parse(response.to_json)
    json["reports"].first["data"]["totals"].first["values"].first.to_i
  end
end