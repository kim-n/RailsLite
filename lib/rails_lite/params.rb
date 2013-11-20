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


  def parse_www_encoded_form(www_encoded_form)
    query_pairs = URI.decode_www_form(www_encoded_form)
    p query_pairs
    new_params = {}
      query_pairs.each do |key, value|
      keys_array = parse_key(key) #["cat", "name"]

      current_hash = new_params

      keys_array.each_with_index do |hash_key, index|
        if( (index+1) == keys_array.count)
          current_hash[hash_key] = value
        else
          current_hash[hash_key] ||= {}
          current_hash = current_hash[hash_key]
        end
      end
    end
    new_params
  end

  #key = "cat[name]"
  def parse_key(key)
    /(\w*)(?:\[(\w*)(?:\])|)/.match(key)[1,2].compact
  end
  #returns ["cat", "name"]
end
