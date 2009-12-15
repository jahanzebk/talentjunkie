require 'rubygems'
require 'net/http'
require 'uri'

# require 'typhoeus'

@api_key = "1cf5c68a32ee955eebb88d1522d2d776"
@secret_key  = "d4c240922e7d23115e501c522b1e77ea"

def _facebook_signature(params)
 params_string = params.sort.map{|pair| pair.join("=")}.join
 Digest::MD5.hexdigest(params_string + @secret_key)
end



url = URI.parse("http://api.facebook.com")

@response = Net::HTTP.start(url.host, url.port) do |http|
  http.get('/restserver.php')
end

puts @response.body



exit(0)
# puts Typhoeus::Request.get("http://api.facebook.com/restserver.php?method=auth.createToken&api_key=1cf5c68a32ee955eebb88d1522d2d776&v=1.0&sig=39ba094929c26c4790e4a403548303c3").body

@request = Typhoeus::Request.new(
                                "http://api.facebook.com/restserver.php",
                                :method           => :get,
                                :timeout          => 100,
                                :cache_timeout    => 5,
                                :follow_location  => true,
                                :params           => { "api_key" => @api_key, "v" => "1.0" }
                     )

@request.on_complete do |response|
 response.body
end                     
                     
                     


@request.params["method"] = "auth.createToken"
@request.params["sig"] = _facebook_signature(@request.params)

@hydra = Typhoeus::Hydra.new(:max_concurrency => 20)
@hydra.queue @request
@hydra.run

puts @request.handled_response