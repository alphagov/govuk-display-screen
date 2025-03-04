require "google/analytics/data/v1beta"

def active_users_yesterday
  client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new

  request = Google::Analytics::Data::V1beta::RunReportRequest.new(
    property: "properties/330577055",
    date_ranges: [
      { start_date: "yesterday", end_date: "yesterday" }
    ],
    metrics: [
      { name: "activeUsers" }
    ]
  )

  response = client.run_report(request) 

  if response.rows.any?
    active_users_yesterday = response.rows[0].metric_values[0].value
  end
end
