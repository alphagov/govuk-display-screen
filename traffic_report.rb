require "google/analytics/data/v1beta"
require 'json'

class TrafficReport
  def visits_per_hour_past_day
    #Needs refactoring!!
    client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new
    request = ::Google::Analytics::Data::V1beta::RunReportRequest.new({
      property: "properties/330577055",
      date_ranges: [
       { start_date: 'yesterday', end_date: 'today'}
      ],
      dimensions: [set_dimension],
      metrics: [set_metric]
    })
    response = client.run_report request
    responses = response.to_h

    rows = responses[:rows]
    formatted = []
    rows.each do |row|
      formatted << {
        hour: row[:dimension_values][0][:value],
        visits: row[:metric_values][0][:value]
      }
    end
    formatted.to_json
  end

  def set_dimension
    Google::Analytics::Data::V1beta::Dimension.new(
      name: "hour"
    )
  end

  def set_metric
    Google::Analytics::Data::V1beta::Metric.new(
      name: "activeUsers"
    )
  end
end
