require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = '/')
    @request = req
    @response = res
    @params = Params.new(@request, route_params)
  end

  def session
    @session ||= Session.new(@request)
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
    @response.status = 302
    @response.header['Location'] = url
    @already_built_response = true
    # @session.store_session(@response)
  end

  def render_content(content, type="text/html")
    @response.body = content
    @response.content_type = type
    @already_built_response = true
    # @session.store_session(@response)
  end

  def render(template_name)
    controller_name = (self.class.to_s.underscore)
    path = "views/#{controller_name}/#{template_name}.html.erb"

    contents =  File.read(path)

    body = ERB.new(contents).result(binding)
    render_content(body)
  end

  def invoke_action(name)
    self.send(name)
    # @response.body = @request.path

    render(name) unless already_rendered?
  end
end
