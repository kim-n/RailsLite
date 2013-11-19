require 'uri'

class Params
  def initialize(req, route_params)
    @params = {}
    if req.query_string
      @params.merge!( parse_www_encoded_form(req.query_string) )
    end
    if req.body
      @params.merge!( parse_www_encoded_form(req.body) )
    end
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    query_pairs = URI.decode_www_form(www_encoded_form)

    new_params = {}
    query_pairs.each{|arr| new_params[arr[0]] = arr[1]}
    new_params
  end

  def parse_key(key)
    @params.keys
  end
end
