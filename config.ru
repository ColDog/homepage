require 'bundler'
require './lib/app'
Dir['./app/controllers/*.rb'].each {|file| require file }

Bundler.require

app = App.new

app.router.config do
  get /\/articles\/(?<title>.*)/, 'ArticlesController#show'
  get /\/articles/,               'ArticlesController#index'
  get /\//,                       'HomeController#index'
end

use Rack::Deflater
use Rack::Static, urls: ['/public'], root: File.expand_path(File.dirname(__FILE__), 'public')
run app
