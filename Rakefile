require 'bundler'
Bundler::GemHelper.install_tasks

load File.expand_path(File.dirname(__FILE__) + '/tasks/fixtures.rake')

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: :spec

require 'gares/version'
require 'rdoc/task'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Gares #{Gares::VERSION} documentation"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << '--webcvs=http://github.com/paulrbr/gares/tree/master/'
end

require 'gokdok'
Gokdok::Dokker.new do |gd|
  gd.repo_url = 'git@github.com:paulrbr/gares.git'
  gd.doc_home = 'rdoc'
  gd.remote_path = '.'
end
