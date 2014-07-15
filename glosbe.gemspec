require 'rubygems'
spec = Gem::Specification.new do |s|
  s.name = 'glosbe'
  s.version = '0.0.8'
  s.summary = "Ruby Client for the Glosbe Api"
  s.description = 'Can translated and provide definitions'
  s.files = Dir.glob("lib/**/**")
  s.licenses = ['MIT']
  s.test_files = Dir.glob("test/*_test.rb")
  s.author = "Jeremy Geros"
  s.email = "jeremy453@gmail.com"
  s.required_ruby_version = '>= 1.9.2'
  s.homepage = 'http://github.com/JeremyGeros/glosbe'
  
  
  s.add_dependency 'httparty', '0.13.1'
  s.add_dependency 'htmlentities', '4.3.2'
end