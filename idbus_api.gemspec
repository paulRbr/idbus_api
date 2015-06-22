$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'idbus_api/version'

Gem::Specification.new do |s|
  s.name        = 'idbus_api'
  s.licenses    = ['MIT']
  s.version     = IdbusApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Paul Bonaud']
  s.email       = ['paul+gh@bonaud.fr']
  s.homepage    = 'http://github.com/paulrbr/idbus_api'
  s.summary     = %q(Easily access the API of iDBUS.)
  s.description = %q(Easily use Ruby or the command line to find information from the iDBUS API.)

  s.rubyforge_project = 'idbus_api'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'api'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'multi_json'
  s.add_development_dependency 'gokdok'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'coveralls'
end
