require 'json'
require 'webrick'

class Session
  def initialize(req)
    app_cookie = req.cookies.select { |cookie| cookie.name == '_rails_lite_app' }.first
    @sesson = app_cookie.nil? ? {} : JSON.parse(app_cookie.value)
  end

  def [](key)
    @sesson[key]
  end

  def []=(key, val)
    @sesson[key] = val
  end

  def store_session(res)
    session_cookie = WEBrick::Cookie.new('_rails_lite_app', @sesson.to_json)
    res.cookies << session_cookie
  end
end
