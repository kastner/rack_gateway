Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
 
  s.name = 'rack_gateway'
  s.version = '0.1'
  s.date = '2009-04-02'
 
  s.description = "Rack Gateway Proxy"
  s.summary     = "Rack Gateway Proxy"
 
  s.authors = ["Erik Kastner"]
  s.email = "kastner@gmail.com"
 
  # = MANIFEST =
  s.files = %w[
    Rakefile
    lib/rack_gateway.rb
    rack_gateway.gemspec
    test/spec_rack_gateway.rb
  ]
  # = MANIFEST =
 
  s.test_files = s.files.select {|path| path =~ /^test\/spec_.*\.rb/}
 
  s.extra_rdoc_files = %w[README.rdoc MIT-LICENSE]
  s.add_dependency 'rack', '~> 0.9.1'
  s.add_dependency 'test-spec', '~> 0.9.0'
  s.add_development_dependency 'json', '>= 1.1'
 
  s.has_rdoc = true
  s.homepage = "http://github.com/kastner/rack_gateway/"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "rack-contrib", "--main", "README"]
  s.require_paths = %w[lib]
  s.rubygems_version = '1.1.1'
end
