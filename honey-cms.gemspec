Gem::Specification.new do |s|
  s.name        = 'honey-cms'
  s.version     = '0.3.13'
  s.date        = '2012-12-08'
  s.summary     = 'CMS'
  s.description = 'Some CMS functionality'
  s.authors     = ['Quinn Shanahan']
  s.email       = 'quinn@tastehoneyco.com'
  s.files       = Dir.glob('{vendor,lib,app}/**/*')
  s.homepage    = 'https://github.com/honeyco/honey-cms'

  s.add_runtime_dependency 'redcarpet', '>= 0'
end
