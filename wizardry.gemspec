require File.expand_path('../lib/wizardry/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Aleksey Magusev']
  gem.email         = ['lexmag@gmail.com']
  gem.description   = gem.summary = "Simple step-by-step wizard for Rails"
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'wizardry'
  gem.require_paths = ['lib']
  gem.version       = Wizardry::VERSION

  gem.add_dependency 'rails', '~> 3.2'

  gem.add_development_dependency 'sqlite3'
end