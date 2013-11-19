require 'json'
require 'webrick'

class Session
  def initialize(req)
    cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
    @sesson = cookie.nil? ? {} : JSON.parse(cookie.value)
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
