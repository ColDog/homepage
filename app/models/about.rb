require 'kramdown'

class About

  def self.description
    gets 'description'
  end

  def self.gets(name)
    content = File.read("#{File.expand_path('../..', File.dirname(__FILE__))}/db/#{name}.md")
    Kramdown::Document.new(content).to_html
  end

end