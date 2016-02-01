require './lib/router'
require './lib/response'
require 'json'

class App
  attr_accessor :router

  def initialize
    @router = Router.new
    @classes = {}
  end

  def get_class(str)
    unless @classes[str]
      klass = str.split('::').inject(Object) { |mod, class_name| mod.const_get(class_name) }
      @classes[str] = klass
    end
    @classes[str]
  end

  def parse_body(body, type)
    if type == 'application/json'
      JSON.parse(body)
    else

    end
  end

  def call(env)
    method = env['REQUEST_METHOD']
    path = env['PATH_INFO']
    params = @router.route_for(method, path)

    if params
      req = Rack::Request.new(env)
      if req.content_type == 'application/json'
        body = JSON.parse(req.body.read)
      else
        body = env['rack.input'].gets
      end

      if body
        params[:params].merge(body)
      end

      puts params

      ctrl = get_class(params[:controller]).new
      ctrl.res = Response.new
      ctrl.params = params[:params]
      ctrl.method = method
      ctrl.action = params[:action]
      ctrl.path = path
      ctrl.controller = params[:controller]

      ctrl.res.body = ctrl.send(params[:action])
      ctrl.res.response
    else
      Response.new(404).response
    end
  end

end
