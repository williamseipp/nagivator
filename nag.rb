require 'sinatra'
require 'tzinfo'
require 'sinatra/content_for'
require 'tilt/erubis'

require_relative 'database_persistence'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
  set :erb, escape_html: true
end

before do
  @storage = DatabasePersistence.new(logger)
end

after do
  @storage.disconnect
end

get '/' do
  user_timezone = 'America/Los_Angeles'
  timezone = TZInfo::Timezone.get(user_timezone)
  current_time = timezone.now.strftime("%-I:%M")

  current_time
end
