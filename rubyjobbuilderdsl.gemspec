Gem::Specification.new do |s|
  s.name        = 'rubyjobbuilderdsl'
  s.version     = '0.0.1'
  s.date        = '2015-11-15'
  s.summary     = 'Ruby Internal DSL for creating Jenkins jobs'
  s.description = 'Ruby Internal DSL for creating Jenkins jobs'
  s.authors     = ['Huy Le']
  s.email       = 'lehuy20@gmail.com'
  s.files       = Dir['**/*']
  s.license     = 'MIT'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'builder'
end
