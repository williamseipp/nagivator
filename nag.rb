require 'sinatra'
require 'sinatra/content_for'
require 'tilt/erubis'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
  set :erb, escape_html: true
end

get '/' do
  Time.now.strftime("%-I:%M")
end
