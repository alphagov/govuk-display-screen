require "google/analytics/data/v1beta"
require 'json'

class RealtimeTraffic
  attr_reader :client
  def initialize
    @client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new
  end

  def active_users
    formatted_responses = {
      active_users_30_minutes: response_hash[:rows][0][:metric_values][0][:value]
    }
    formatted_responses.to_json
  end

private

  def request
    { property: "properties/330577055", metrics: [set_metric] }
  end

  def set_metric
    #https://developers.google.com/analytics/devguides/reporting/data/v1/api-schema#metrics
    Google::Analytics::Data::V1beta::Metric.new(
      name: "activeUsers"
    )
  end

  def response
    client.run_realtime_report(request)
  end

  def response_hash
    response.to_h
  end
end
