Gem::Specification.new do |s|
  s.name        = 'honey-cms'
  s.version     = '0.4.1'
  s.date        = '2012-12-08'
  s.summary     = 'CMS'
  s.description = 'Some CMS functionality'
  s.authors     = ['Quinn Shanahan']
  s.email       = 'quinn@tastehoneyco.com'
  s.files       = Dir.glob('{vendor,lib,app}/**/*')
  s.homepage    = 'https://github.com/honeyco/honey-cms'

  s.add_runtime_dependency 'redcarpet', '>= 0'
  s.add_runtime_dependency 'kaminari', '>= 0'
  s.add_runtime_dependency 'carrierwave', '>= 0'
end
