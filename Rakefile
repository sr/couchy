require 'rake'
require 'spec/rake/spectask'
require 'rcov/rcovtask'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
	t.spec_files = FileList['spec/*_spec.rb']
end

desc "Print specdocs"
Spec::Rake::SpecTask.new(:doc) do |t|
	t.spec_opts = ["--format", "specdoc", "--dry-run"]
	t.spec_files = FileList['spec/*_spec.rb']
end

task :default => :spec

task :coverage => :"coverage:verify"
Rcov::RcovTask.new('coverage:generate') do |t|
  t.rcov_opts << '--no-html'
  t.test_files = FileList['spec/*_spec.rb']
  t.rcov_opts << '-Ilib'
  t.rcov_opts << '-x"home"'
  t.verbose = true
end
