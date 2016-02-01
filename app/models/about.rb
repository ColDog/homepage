require 'github/markdown'

class About

  def self.description
    gets 'description'
  end

  def self.gets(name)
    content = File.read("#{File.expand_path('../..', File.dirname(__FILE__))}/db/#{name}.md")
    GitHub::Markdown.render_gfm(content)
  end

end