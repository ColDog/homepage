require 'erb'

class Controller
  attr_accessor :params, :res, :path, :method, :action, :controller
  CACHE_KEYS = {}

  def self.cache_key(action, key)
    CACHE_KEYS[self.name] = CACHE_KEYS[self.name] || {}
    CACHE_KEYS[self.name][action] = key
  end

  def get_binding
    binding
  end

  def cache_key
    if @cache_key
      @cache_key
    elsif CACHE_KEYS[self.class.name] && CACHE_KEYS[self.class.name][action]
      cache_key = CACHE_KEYS[self.class.name][action]
      if cache_key.is_a? Symbol
        @cache_key = "#{controller}-#{action}:#{send(cache_key)}"
      else
        @cache_key ="#{controller}-#{action}:#{cache_key}"
      end
    end
  end

  def from_cache(tpl)
    path = "#{File.expand_path('..', File.dirname(__FILE__))}/storage/cache/#{cache_key}"
    if File.exists?(path)
      html = IO.read(path)
    else
      html = _render(tpl)
      IO.write(path, html)
    end
    html
  end

  def render(tpl)
    if cache_key
      from_cache(tpl)
    else
      _render(tpl)
    end
  end

  def _render(tpl)
    content = File.open("#{File.expand_path('..', File.dirname(__FILE__))}/app/views/#{tpl}.erb", "rb").read
    ERB.new(content).result(self.get_binding)
  end
end
