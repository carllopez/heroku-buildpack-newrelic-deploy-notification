#!/usr/bin/env ruby

require 'json'

env_dir = ENV['ENV_DIR']
new_relic_license_key = `cat #{env_dir}/NEW_RELIC_LICENSE_KEY`
new_relic_app_id = `cat #{env_dir}/NEW_RELIC_APP_ID`

params = {
  deployment: {
    revision: ENV['SOURCE_VERSION']
  }
}

cmd = <<-CMD.gsub(/\s+/, ' ')
curl -X POST 'https://api.newrelic.com/v2/applications/#{new_relic_app_id}/deployments.json' 
     -H 'X-Api-Key:#{new_relic_license_key}' -i 
     -H 'Content-Type: application/json' 
     -d 
     '#{params.to_json}'
CMD
puts cmd
system cmd
