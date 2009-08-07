require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the rosetta plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Test coverage report for the rosetta plugin.'
Rcov::RcovTask.new(:coverage) do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
  t.output_dir = "test/coverage/"
  t.verbose = true
  t.rcov_opts << '--exclude "/Library/*"'
end

desc 'Generate documentation for the rosetta plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Rosetta'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end