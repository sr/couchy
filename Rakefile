require 'rake'
require 'spec/rake/spectask'
require 'rcov/rcovtask'
require 'yard'

task :default => :test

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
	t.spec_files = FileList['spec/*_spec.rb']
end

desc "Print specdocs"
Spec::Rake::SpecTask.new(:doc) do |t|
	t.spec_opts = ["--format", "specdoc", "--dry-run"]
	t.spec_files = FileList['spec/*_spec.rb']
end

task :test do
  sh 'testrb test/*.rb'
end

task :coverage => :"coverage:verify"
Rcov::RcovTask.new('coverage:generate') do |t|
  t.test_files = FileList['test/*_test.rb']
  t.rcov_opts << '-Ilib'
  t.rcov_opts << '-x"home"'
  t.verbose = true
end

YARD::Rake::YardocTask.new
