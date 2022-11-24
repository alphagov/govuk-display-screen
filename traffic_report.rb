require "google/analytics/data/v1beta"
require 'json'

class TrafficReport
  attr_reader :client
  def initialize
    @client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new
  end

  def visits_per_hour_past_day
    begin
      rows = response_hash[:rows]
    rescue StandardError => e
      puts "#{e.message}"
      {
        hour: "No data available",
        visits: "No data available"
      }.to_json
    else
      formatted = []
      rows.each do |row|
        formatted << {
          hour: row.dig(:dimension_values).first.dig(:value),
          visits: row.dig(:metric_values).first.dig(:value)
        }
      end
      formatted.to_json
    end
  end

private

  def request
    ::Google::Analytics::Data::V1beta::RunReportRequest.new({
      property: "properties/330577055",
      date_ranges: [
       { start_date: 'yesterday', end_date: 'today'}
      ],
      dimensions: [set_dimension],
      metrics: [set_metric],
      order_bys: [set_order],
      limit: 25,
      offset: 0
    })
  end

  def set_dimension
    #https://developers.google.com/analytics/devguides/reporting/data/v1/api-schema#dimensions
    Google::Analytics::Data::V1beta::Dimension.new(
      name: "hour"
    )
  end

  def set_metric
    #https://developers.google.com/analytics/devguides/reporting/data/v1/api-schema#metrics
    Google::Analytics::Data::V1beta::Metric.new(
      name: "activeUsers"
    )
  end

  def set_order
    Google::Analytics::Data::V1beta::OrderBy.new(
      {
        dimension: Google::Analytics::Data::V1beta::OrderBy::DimensionOrderBy.new(
          {
            dimension_name: 'hour',
            order_type: Google::Analytics::Data::V1beta::OrderBy::DimensionOrderBy::OrderType::NUMERIC
        
          }
        ),
        desc: true 
      }
    )
  end

  def response
    client.run_report request
  end

  def response_hash
    response.to_h
  end
end
