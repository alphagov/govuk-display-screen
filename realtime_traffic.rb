require "google/analytics/data/v1beta"
require 'json'

class RealtimeTraffic
  def active_users
    client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new
    response = client.run_realtime_report({ property: "properties/330577055", metrics: [set_metric] })
    response.to_json #needs formatting
  end

  def set_metric
    Google::Analytics::Data::V1beta::Metric.new(
      name: "activeUsers"
    )
  end
end
