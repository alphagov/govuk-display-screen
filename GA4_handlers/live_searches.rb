require 'google-analytics-data-v1beta'

def live_searches 
  client = Google::Analytics::Data::V1beta::AnalyticsData::Client.new

  # Define the metric for active users
  metric = Google::Analytics::Data::V1beta::Metric.new(
    name: "activeUsers"
  )

  # Define the dimension for page path (slug)
  dimension = Google::Analytics::Data::V1beta::Dimension.new(
    name: "unifiedScreenName"  # This provides the slug only
  )

  # page_location_dimension = Google::Analytics::Data::V1beta::Dimension.new(
  #   name: "page_location"  # This provides the slug only
  # )

  # Prepare the request
  req = {
    property: "properties/330577055", # Your GA4 property ID
    metrics: [metric],
    dimensions: [
      dimension,
      # page_location_dimension
    ],
    limit: 20
  }

  # Run the report
  response = client.run_realtime_report(req)
  result = response.to_h


  # Extract the active users data with page path (slug)
  data = result[:rows].map do |row|
    {
      page_slug: row[:dimension_values].first[:value],
      active_users_count: row[:metric_values].first[:value]
    }
  end

  data.to_json
end
