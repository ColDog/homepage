require './app/models/article'
require './lib/controller'

class ArticlesController < Controller
  cache_key 'show', :show_key

  def show
    @description = About.description
    @article = Article.find(params['title'])
    if @article
      render 'article'
    else

    end
  end

  private
  def show_key
    params['title']
  end

end