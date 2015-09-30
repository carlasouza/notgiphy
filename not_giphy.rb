require 'rubygems'
require 'sinatra'

set :root, File.dirname(__FILE__)
set :dump_errors, true
set :raise_errors, false
set :show_exceptions, false
set :port, 80

# Payload from slack:
# {
#   "token"=>"XXXXXXXXX",
#   "team_id"=>"XXXXXXX",
#   "team_domain"=>"XXXXXX",
#   "channel_id"=>"XXXXXXX",
#   "channel_name"=>"directmessage",
#   "user_id"=>"XXXXXXX",
#   "user_name"=>"carla",
#   "command"=>"/notgiphy",
#   "text"=>"doge"
# }
post '/' do
  begin
    debug("Params: #{params}")

    require_relative './imgur.rb'
    query = params[:text]
    where = params[:channel_name]
    who = params[:user_name]
    channel = params[:channel_id]

    @gifs = Imgur.gifs(params[:text])
    @choosen = @gifs.shuffle.first
    res = @choosen['link']

    debug("#{params['team_domain']} #{res}")
    debug(gen_payload(query, res, channel, who))
    debug(callback(query, res, channel, who))
  rescue
    "Something went wrong :sad:"
  end
end

get '/' do
  CGI.escapeHTML 'NotGiphy - Copyright Carla Souza <contact@carlasouza.com>'
end

get '/robots.txt' do
 'User-agent: *'
end

get '/ta' do
  CGI.escapeHTML 'Copyright Carla Souza <contact@carlasouza.com>'
end

def callback query, res, channel, who
    uri = URI.parse(ENV['SLACK_URI']) # https://hooks.slack.com
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(ENV['SLACK_ENDPOINT']) # /T0000000/B000000000/XXXXXXXXXXXX
    request.body = gen_payload(query, res, channel, who)
    http.request(request)
    return
end

def gen_payload query, res, channel, who
    "payload={\"text\":\"'#{query}' by @#{who}: <#{res}>\", \"username\":\"notgiphy\", \"channel\":\"#{channel}\", \"icon_emoji\":\":beers:\"}"
end

def debug msg
  puts "[DEBUG] #{msg}"
end

__END__
