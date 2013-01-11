require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require 'json'

ENV['RACK_ENV'] ||= 'development'
ENV['DATABASE_URL'] ||= "postgres://postgres@localhost/tentacles_#{ENV['RACK_ENV']}"

db = URI.parse(ENV['DATABASE_URL'])

DB_SETTINGS = {
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8',
  :pool     => 10,
  :port     => db.port,
}

ActiveRecord::Base.establish_connection(DB_SETTINGS)

%w[lib server server/models].each do |dir|
  Dir.glob("./#{dir}/*.rb").each do |relative_path|
    p relative_path
    require relative_path  unless relative_path == "./server/application.rb"
  end
end

set :sprockets, SprocketsEnvironmentBuilder.build(ENV['RACK_ENV'])

configure :production, :test do
  set :raise_errors, false
  set :show_exceptions, false
+end

configure :production do
  require 'newrelic_rpm'
  # Ensure the agent is started using Unicorn
  # This is needed when using Unicorn and preload_app is not set to true.
  # See http://support.newrelic.com/kb/troubleshooting/unicorn-no-data
  NewRelic::Agent.after_fork(:force_reconnect => true) if defined? Unicorn
end

class App < Sinatra::Base
  register Sinatra::Contrib
  set :root, File.expand_path(".")
  set :public_folder, Proc.new { File.join(root, "client/public") }
  set :views, Proc.new { File.join(root, "client/views") }
end
