def popular_content
  client = ::Google::Analytics::Data::V1beta::AnalyticsData::Client.new

  start_date = Date.today - 6
  end_date = Date.today

  past_week = { start_date: start_date.to_s, end_date: end_date.to_s}

  path_dimension = Google::Analytics::Data::V1beta::Dimension.new(
    name: "pagePath"
  )
  title_dimension = Google::Analytics::Data::V1beta::Dimension.new(
    name: "pageTitle"
  )
  screen_page_views_metric = Google::Analytics::Data::V1beta::Metric.new(
    name: "screenPageViews"
  )

  request = ::Google::Analytics::Data::V1beta::RunReportRequest.new({
    property: "properties/330577055",
    date_ranges: [
      past_week
    ],
    dimensions: [path_dimension, title_dimension],
    metrics: [screen_page_views_metric],
    limit: 10
  })


  response = client.run_report request
  response_hash = response.to_h


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
      other_result = page_title == "(other)"
      unless other_result
        to_format = row.dig(:metric_values).first.dig(:value)
        formatted_page_views_with_commas = to_format.reverse.chars.each_slice(3).map(&:join).join(',').reverse
        row_data = {
          page_views: formatted_page_views_with_commas,
          page_path: row.dig(:dimension_values).first.dig(:value),
          page_title: page_title
        }
        formatted << row_data
      end
    end
    formatted.to_json
  end
end