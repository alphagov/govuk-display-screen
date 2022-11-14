require "google/analytics/data/v1beta"
require 'json'

class RealtimeTraffic
  attr_reader :client
  def initialize
    @client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new
  end

  def active_users
    begin
      formatted_responses = {
        active_users_30_minutes: response_hash.dig(:rows).first.dig(:metric_values).first.dig(:value)
      }
    rescue StandardError => e
      puts "#{e.message}"
      {active_users_30_minutes: "No data available"}.to_json
    else
      formatted_responses.to_json
    end
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
