$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'autotune/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'autotune'
  s.version     = Autotune::VERSION
  s.authors     = ['Ryan Mark']
  s.email       = ['ryan@mrk.cc']
  s.homepage    = 'https://github.com/voxmedia/autotune'
  s.summary     = 'Fancy way to turn templates into web pages'
  # s.description = 'TODO: Description of Autotune.'
  s.license     = 'BSD'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.3'
  s.add_dependency 'omniauth', '~> 1.2.2'
  s.add_dependency 'resque', '~> 1.25.2'
  s.add_dependency 'resque-scheduler', '~> 4.0.0'
  s.add_dependency 'jbuilder', '~> 2.0'
  s.add_dependency 's3deploy', '~> 0.2'
  s.add_dependency 'autoshell', '> 0'
  s.add_dependency 'bootstrap-sass', '~> 3.3.4'
  s.add_dependency 'bootstrap3-datetimepicker-rails', '~> 4.15.35'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency 'will_paginate', '~> 3.0.7'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'pry-rails'
end
