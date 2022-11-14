require "google/analytics/data/v1beta"
require 'date'
require 'json'

class Content
  attr_reader :client
  def initialize
    @client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new
  end

  def most_popular_govuk_pages
    rows = response_hash[:rows]
    formatted = []
    rows.each do |row|
      row_data = {
        page_views: row[:metric_values][0][:value],
        page_path: row[:dimension_values][0][:value],
        page_title: row[:dimension_values][1][:value]
      }
      formatted << row_data
    end
    formatted.to_json  
  end

private

  def request
    ::Google::Analytics::Data::V1beta::RunReportRequest.new({
      property: "properties/330577055",
      date_ranges: [
        set_date_range
      ],
      dimensions: [set_dimension_path, set_dimension_title],
      metrics: [set_metric],
      limit: 10
    })
  end

  def set_dimension_path
    #https://developers.google.com/analytics/devguides/reporting/data/v1/api-schema#dimensions
    Google::Analytics::Data::V1beta::Dimension.new(
      name: "pagePath"
    )
  end

  def set_dimension_title
    Google::Analytics::Data::V1beta::Dimension.new(
      name: "pageTitle"
    )
  end

  def set_metric
    #https://developers.google.com/analytics/devguides/reporting/data/v1/api-schema#metrics
    Google::Analytics::Data::V1beta::Metric.new(
      name: "screenPageViews"
    )
  end

  def set_date_range
    start_date = Date.today - 6
    end_date = Date.today

    { start_date: start_date.to_s, end_date: end_date.to_s}
  end

  def response
    client.run_report request
  end

  def response_hash
    response.to_h
  end
end
