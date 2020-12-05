# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'octokit'

ACCESS_TOKEN = '9005c9883582478a02f9a2cc0598012ec55b1834'

before { @client ||= Octokit::Client.new(access_token: ACCESS_TOKEN) }

post '/event_handler' do
  payload = JSON.parse(params[:payload])

  puts "HERE #{ACCESS_TOKEN}"

  case request.env['HTTP_X_GITHUB_EVENT']
  when 'pull_request'
    if payload['action'] == 'opened'
      process_pull_request(payload['pull_request'])
    end
  end
end

helpers do
  def process_pull_request(pull_request)
    @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'pending', { context: 'test'})
    sleep 2 # do busy work...
    @client.create_status(pull_request['base']['repo']['full_name'], pull_request['head']['sha'], 'success', { context: 'test'})
    puts "Pull request processed!"
  end
end
