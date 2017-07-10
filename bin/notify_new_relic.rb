#!/usr/bin/env ruby

require 'json'

env_dir = ENV['ENV_DIR']
new_relic_api_key = `cat #{env_dir}/NEW_RELIC_API_KEY`
new_relic_app_id = `cat #{env_dir}/NEW_RELIC_APP_ID`
deployer = `cat #{env_dir}/DEPLOYER`
commit_id = ENV['SOURCE_VERSION']

params = {
  deployment: {
    revision: commit_id,
    changelog: 'Deploying #{commit_id}',
    description: 'Deploying #{commit_id}',
    user: deployer
  }
}

cmd = <<-CMD.gsub(/\s+/, ' ')
curl -X POST 'https://api.newrelic.com/v2/applications/#{new_relic_app_id}/deployments.json'
     -H 'X-Api-Key:#{new_relic_api_key}' -i
     -H 'Content-Type: application/json'
     -s
     -d
     '#{params.to_json}'
     > /dev/null 2>&1
CMD
raise "Error: #{cmd}" unless system(cmd)
