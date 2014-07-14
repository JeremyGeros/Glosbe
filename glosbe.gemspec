require 'rubygems'
spec = Gem::Specification.new do |s|
  s.name = 'glosbe'
  s.version = '0.0.1'
  s.summary = "Ruby Client for the Glosbe Api"
  s.files = Dir.glob("**/**/**")
  s.test_files = Dir.glob("test/*_test.rb")
  s.author = "Jeremy Geros"
  s.email = "jeremy453@gmail.com"
  s.required_ruby_version = '>= 1.9.2'
  
  
  s.add_dependency 'httparty', '>=0.7.8'
end