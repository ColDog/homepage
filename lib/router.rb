class Router
  attr_reader :routes
  def initialize
    @routes = {get: [], post: [], delete: []}
  end

  def config(&block)
    instance_eval &block
  end

  def get(path, controller)
    klass, method = controller.split('#')
    @routes[:get] << {
        controller: klass,
        action: method,
        path: path
    }
  end

  def route_for(method, route)

    @routes[method.downcase.to_sym].each do |path|
      match = path[:path].match(route)
      if match
        return {
            route: route,
            controller: path[:controller],
            params: match.names ? Hash[match.names.zip(match.captures)] : {},
            action: path[:action]
        }
      end
    end

    false
  end
end
