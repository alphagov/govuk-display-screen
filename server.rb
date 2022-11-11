require 'rubygems'
require 'sinatra'
require 'json'
require 'rack-cache'
require 'net/http'
require 'net/https'
require 'active_support'
require 'active_support/core_ext/hash'
require 'dotenv/load'
require_relative 'content'
require_relative 'realtime_traffic'
require_relative 'traffic_report'

use Rack::Cache
set :public_folder, 'public'
set :bind, '0.0.0.0'
set :protection, :except => :frame_options

if ENV['USERNAME'] && ENV['PASSWORD']
  use Rack::Auth::Basic, 'Demo area' do |user, pass|
    user == ENV['USERNAME'] && pass == ENV['PASSWORD']
  end
end

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/search' do
  File.read(File.join('public', 'search.html'))
end

get '/brexit' do
  File.read(File.join('public', 'brexit.html'))
end

get '/corona' do
  File.read(File.join('public', 'corona.html'))
end

get '/realtime' do
  cache_control :public, :max_age => 20
  query = { :access_token => get_token }.merge(params)

  http = Net::HTTP.new('www.googleapis.com', 443)
  http.use_ssl = true
  req = Net::HTTP::Get.new("/analytics/v3alpha/data/realtime?#{query.to_param}")
  response = http.request(req)
  response.body
end

get '/feed' do
  http = Net::HTTP.new('www.gov.uk', 443)
  http.use_ssl = true
  req = Net::HTTP::Get.new('/government/feed')
  response = http.request(req)
  JSON.generate Hash.from_xml(response.body)
end

get '/popular-content' do
  content_type :json

  content = Content.new()
  content.most_popular_govuk_pages
end

get '/realtime-traffic' do
  content_type :json
  traffic = RealtimeTraffic.new
  traffic.active_users
end

get '/traffic-report' do
  content_type :json
  traffic = TrafficReport.new
  traffic.visits_per_hour_past_day
end

def get_token
  if @token.nil? || @token_timeout < Time.now
    params = {
      'client_id' => ENV['CLIENT_ID'],
      'client_secret' => ENV['CLIENT_SECRET'],
      'refresh_token' => ENV['REFRESH_TOKEN'],
      'grant_type' => 'refresh_token'
    }
    http = Net::HTTP.new('accounts.google.com', 443)
    http.use_ssl = true
    req = Net::HTTP::Post.new('/o/oauth2/token')
    req.form_data = params
    response = http.request(req)
    data = JSON.parse(response.body)
    @token_timeout = Time.now + data["expires_in"]
    @token = data["access_token"]
  end
  @token
end
