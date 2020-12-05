# frozen_string_literal: true

require 'sinatra'
require 'json'

post '/event_handler' do
  payload = JSON.parse(params[:payload])

  case request.env['HTTP_X_GITHUB_EVENT']
  when 'pull_request'
    puts 'Opened !' if payload['action'] == 'opened'
  end
end
