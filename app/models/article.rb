require 'github/markdown'
require 'date'

class Article

  def initialize(name, content)
    @name = name
    @title = content.split("\n")[0]
    @date = content.split("\n")[1]
    @body = content.split("\n")[2..-1].join("\n")
  end

  def name
    @name
  end

  def title
    @title
  end

  def date
    @date
  end

  def body(len=nil)
    if len
      @body = @body[0, len] + '...'
    end
    GitHub::Markdown.render_gfm(@body)
  end

  def self.all
    articles = []
    Dir["#{File.expand_path('../..', File.dirname(__FILE__))}/db/articles/*.article"].each do |uri|
      articles << self.find(File.basename(uri).split('.article')[0])
    end
    articles.sort! { |a, b| Date.parse(b.date) <=> Date.parse(a.date) }
  end

  def self.find(name)
    file = "#{File.expand_path('../..', File.dirname(__FILE__))}/db/articles/#{name}.article"
    if File.exists? file
      self.new(name, File.new(file).read)
    end
  end

end