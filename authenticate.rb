# frozen_string_literal: true

require 'base64'

def authenticate
  if ENV['ANALYTICS_DATA_CREDENTIALS']
    # If ANALYTICS_DATA_CREDENTIALS is already set, assume it's pointing to a local file
    puts 'Using local credentials from ANALYTICS_DATA_CREDENTIALS.'
  else
    unless ENV['HEROKU_ANALYTICS_DATA_CREDENTIALS']
      raise 'HEROKU_ANALYTICS_DATA_CREDENTIALS environment variable is not set.'
    end

    # Decode the service account JSON from the HEROKU_ANALYTICS_DATA_CREDENTIALS environment variable
    service_account_json = Base64.decode64(ENV['HEROKU_ANALYTICS_DATA_CREDENTIALS'])

    # Determine the path to key_temp.py in the same directory as the current script
    current_directory = File.dirname(__FILE__)
    service_account_file_path = File.join(current_directory, 'key_temp.json')

    # Write the decoded JSON to key_temp.py, overriding the file if it already exists
    File.open(service_account_file_path, 'w') do |file|
      file.write(service_account_json)
    end

    # Set the environment variable to the path of the file
    ENV['ANALYTICS_DATA_CREDENTIALS'] = service_account_file_path

    puts 'Using credentials from HEROKU_ANALYTICS_DATA_CREDENTIALS and writing to key_temp.json.'

  end
end
