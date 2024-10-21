require_relative "authenticate"
authenticate()


require 'rubygems'
require 'sinatra'
require 'json'
require 'rack-cache'
require 'net/http'
require 'net/https'
require 'active_support'
require 'active_support/core_ext/hash'
require 'dotenv/load'
require "google/analytics/data/v1beta"
require_relative 'GA4_handlers/active_users'
require_relative 'GA4_handlers/popular_content'
require_relative 'GA4_handlers/live_searches'
autoload :Google, 'google-analytics-data-v1beta'





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

get '/live-searches' do
  content_type :json
  most_popular_search_terms
end

get '/popular-content' do
  content_type :json
  popular_content
end

get '/active-users' do
  content_type :json
  active_users
end
