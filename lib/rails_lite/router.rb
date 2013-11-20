class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    #controller_class   http_method   pattern        action_name
    #   user              PUT           /users/:id      users#update
    #   user             :put           /users/:id      users#update

    @pattern = patterm
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    http_method == req.request_method.downcase.to_sym
  end

  def run(req, res)
     ControllerBase.new(req,res).invoke_action(@action_name)
  end
end

class Router
  # given an HTTPRequest, figure out which Route matches the requested URL.
  # Once found, instantiate the Route's controller, and run the appropriate method.


  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
  end

  # add a Route object to the Router's @routes instance variable.
  [:get, :post, :put, :delete].each do |http_method|
    # add these helpers in a loop here
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  # figure out what URL was requested,
  # match it to the URL regex of one Route object, and
  # finally ask the Route to instantiate the appropriate controller,
  # and call the approriate method.
  def run(req, res)
    route = match(req)
    if route
      route.run(req, res)
    else
      res.status = "404"
    end
  end
end
