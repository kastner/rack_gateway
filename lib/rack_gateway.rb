require 'curb'

module Rack
  class Gateway
    attr_accessor :env
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      self.dup._call(env)
    end
    
    def upstream_url
      # raise env.inspect
      "%s://%s%s%s" % [
        @env["rack.url_scheme"],
        ENV["upstream_server"],
        @env["PATH_INFO"],
        @env["QUERY_STRING"].empty? ? "" : "?#{@env["QUERY_STRING"]}"
      ]
    end
    
    def request_headers
      headers = @env.select {|k,v| k.match(/^HTTP_/)}.map do |key, value|
        my_key = key.gsub(/^HTTP_/, '').gsub(/_/, '-').downcase.capitalize
        [my_key, value]
      end
      headers = Hash[*headers.flatten]
    end
    
    def response_headers(curl)
      headers = curl.header_str.split("\r\n")[1..-1].map{|h| h.split(": ")}
      headers
      Hash[*headers.flatten]
    end
    
    def _call(env)
      @env = env
      @status, @headers, @response = @app.call(@env)
      
      if @status == 404
        c = Curl::Easy.new(upstream_url)
        c.headers = request_headers
        case @env["REQUEST_METHOD"]
        when /get/i
          c.perform
        when /post/i
          c.http_post(@env["rack.request.form_vars"])
        end
        @response = c.body_str
        @status = c.response_code
        @headers = response_headers(c)
      end
      
      [@status, @headers, @response]
    end
  end
end