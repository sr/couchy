require 'rake'
require 'spec/rake/spectask'
require 'rcov/rcovtask'
require 'yard'

task :default => :test

task :test => :"test:all"

namespace :test do
  desc 'Run all tests'
  task :all => [:unit, :integration]

  desc 'Run unit tests'
  task :unit do
    sh 'testrb test/*.rb'
  end

  desc "Run integration tests"
  Spec::Rake::SpecTask.new('integration') do |t|
    t.spec_files = FileList['spec/*_spec.rb']
  end
end

Rcov::RcovTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.rcov_opts << '-Ilib'
  t.rcov_opts << '-x"home"'
  t.verbose = true
end

YARD::Rake::YardocTask.new

task :public => [:"publish:doc", :"publish:coverage"]

namespace :publish do
  task :doc => :yardoc do
    sh 'cp -r doc ~/web/atonie.org/2008/couchy'
    sh 'cd ~/web/atonie.org && git add 2008/couchy/doc && git commit -m "update couchy doc"'
  end

  task :coverage => :rcov do
    sh 'cp -r coverage ~/web/atonie.org/2008/couchy'
    sh 'cd ~/web/atonie.org && git add 2008/couchy/coverage && git commit -m "update couchy coverage"'
  end
end
