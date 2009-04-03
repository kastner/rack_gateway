require 'test/spec'
require 'rack/mock'
require 'rack_gateway'
 
context 'Rack::Gateway' do
  before(:each) do
    ENV["upstream_server"] = "localhost"
    @test_headers = {'Content-Type' => 'text/html'}
    @test_body = "Not Found"
    @app = lambda { |env| [404, @test_headers, [@test_body]]}
    @gateway = Rack::Gateway.new(@app)
  end
  
  specify "request url should be set" do
    request = Rack::MockRequest.env_for("/bob", :lint => true, :fatal => true)
    @gateway.env = request
    @gateway.upstream_url.should.equal "http://localhost/bob"
  end

  specify "request url should be set even with a query string" do
    request = Rack::MockRequest.env_for("/bob?a=1", :lint => true, :fatal => true)
    @gateway.env = request
    @gateway.upstream_url.should.equal "http://localhost/bob?a=1"
  end
  
  specify "forwarding request should pass-through headers" do
    request = Rack::MockRequest.env_for("/bob", {
      :lint => true, :fatal => true, 
      "HTTP_ACCEPT" => "application/xml,text/html;q=0.9,*/*;q=0.5",
      "HTTP_USER_AGENT" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/528.16 (KHTML, like Gecko) Version/4.0 Safari/528.16"
    })
    @gateway.env = request
    @gateway.request_headers.should.include?("User-agent")
    @gateway.request_headers['User-agent'].should.match /Safari/
  end
  
  # specify "A POST should forward the post data" do
  # end
end
