require 'tempfile'
require 'base64'

def authenticate
  if ENV['ANALYTICS_DATA_CREDENTIALS']
    # If GOOGLE_APPLICATION_CREDENTIALS is already set, assume it's pointing to a local file
    puts "Using local credentials from ANALYTICS_DATA_CREDENTIALS."
  else
    # Decode the service account JSON from the ANALYTICS_DATA_CREDENTIALS environment variable
    if ENV['HEROKU_ANALYTICS_DATA_CREDENTIALS']
      service_account_json = Base64.decode64(ENV['HEROKU_ANALYTICS_DATA_CREDENTIALS'])

      # Write the decoded JSON to a temporary file
      service_account_file = Tempfile.new('service_account')
      service_account_file.write(service_account_json)
      service_account_file.rewind

      # Set the GOOGLE_APPLICATION_CREDENTIALS env var to the path of the temporary file
      ENV['ANALYTICS_DATA_CREDENTIALS'] = service_account_file.path

      puts "Using credentials from HEROKU_ANALYTICS_DATA_CREDENTIALS and writing to a temp file."
    else
      raise "HEROKU_ANALYTICS_DATA_CREDENTIALS environment variable is not set."
    end
  end
end