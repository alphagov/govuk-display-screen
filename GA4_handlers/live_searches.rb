require "google/analytics/data/v1beta"


def most_popular_search_terms
  # Gets the most searched search terms for the last 30min
  # By selecting the 2000 most popular pages
  # And filtering out the ones that are not search results

  client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new

  metric = Google::Analytics::Data::V1beta::Metric.new(
    name: "activeUsers"
  )

  dimension = Google::Analytics::Data::V1beta::Dimension.new(
    name: "unifiedScreenName"  # This provides the title of the page
  )

  req = {
    property: "properties/330577055",
    metrics: [metric],
    dimensions: [dimension],
    limit: 2000
  }

  response = client.run_realtime_report(req)

  data = []

  response.rows.each do |row|
    page_title = row.dimension_values.first.value
    active_users_count = row.metric_values.first.value.to_i

    if page_title.include?(" - Search - ")
      search_term = page_title.split(" - Search - ").first

      data << {
        page_slug: search_term,
        active_users_count: active_users_count
      }
    end
  end

  data.to_json
end