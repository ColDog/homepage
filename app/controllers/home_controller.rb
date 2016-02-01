require './lib/controller'
require './app/models/about'
require './app/models/article'

class HomeController < Controller
  cache_key 'index', 'v1'

  def index
    @description = About.description
    @articles = Article.all
    render 'home'
  end
end