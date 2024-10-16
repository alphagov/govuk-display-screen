require 'google-analytics-data-v1beta'

def active_users
  client = Google::Analytics::Data::V1beta::AnalyticsData::Client.new
  metric = Google::Analytics::Data::V1beta::Metric.new(
    name: "activeUsers"
  )
  req = { property: "properties/330577055", metrics: [metric] }

  au = client.run_realtime_report(req) 

  h = au.to_h

  nb_active_users = h.dig(:rows).first.dig(:metric_values).first.dig(:value)
  { active_users_30_minutes: nb_active_users }.to_json
end