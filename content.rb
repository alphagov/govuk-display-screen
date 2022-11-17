require "google/analytics/data/v1beta"
require 'date'
require 'json'

class Content
  attr_reader :client
  def initialize
    @client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new
  end

  def most_popular_govuk_pages
    begin
      rows = response_hash[:rows]
    rescue StandardError => e
      puts "#{e.message}"
      [
        {
          page_views: "No data available",
          page_path: "",
          page_title: "No data available"
        }.to_json
      ]
    else
      formatted = []
      rows.each do |row|
        page_title = row.dig(:dimension_values)[1].dig(:value)
        unless other_result(page_title)
          row_data = {
            page_views: format_page_views_with_commas(row.dig(:metric_values).first.dig(:value)),
            page_path: row.dig(:dimension_values).first.dig(:value),
            page_title: page_title
          }
          formatted << row_data
        end
      end
      formatted.to_json
    end
  end

private

  def other_result(page_title)
    #Sometimes the API returns '(other)' results which skew the data:
    #https://support.google.com/analytics/answer/9309767#zippy=%2Cin-this-article.
    #It doesn't look like we can eliminate them using the API query itself.
    #There are only max 10 results, so a Ruby check has been added to eliminate (other) results.
    page_title == "(other)"
  end

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

  def format_page_views_with_commas(page_views)
    page_views.reverse.chars.each_slice(3).map(&:join).join(',').reverse
  end
end