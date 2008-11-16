Gem::Specification.new do |s|
  s.name     = 'couchy'
  s.version  = '0.0.2'
  s.date     = '2008-10-07'
  s.summary  = 'Simple, no-frills, Ruby wrapper around the nice CouchDB HTTP API'
  s.description = 'Simple, no-frills, Ruby wrapper around the nice CouchDB HTTP API'
  s.homepage = 'http://github.com/sr/couchy'
  s.email    = 'simon@rozet.name'
  s.authors  = ['Simon Rozet']
  s.has_rdoc = false
  s.executables = ['couchy']

  s.files = %(
    README.textile
    Rakefile
    bin/couchy
    couchy.gemspec
    lib/couchy.rb
    lib/couchy/database.rb
    lib/couchy/server.rb
    spec/couchy_spec.rb
    spec/database_spec.rb
    spec/fixtures/attachments/test.html
    spec/fixtures/views/lib.js
    spec/fixtures/views/test_view/lib.js
    spec/fixtures/views/test_view/only-map.js
    spec/fixtures/views/test_view/test-map.js
    spec/fixtures/views/test_view/test-reduce.js
    spec/spec.opts
    spec/spec_helper.rb
    test/couchy_test.rb
    test/database_test.rb
    test/server_test.rb
    test/test_helper.rb
    vendor/addressable/.gitignore
    vendor/addressable/CHANGELOG
    vendor/addressable/LICENSE
    vendor/addressable/README
    vendor/addressable/Rakefile
    vendor/addressable/lib/addressable/idna.rb
    vendor/addressable/lib/addressable/uri.rb
    vendor/addressable/lib/addressable/version.rb
    vendor/addressable/spec/addressable/idna_spec.rb
    vendor/addressable/spec/addressable/uri_spec.rb
    vendor/addressable/spec/data/rfc3986.txt
    vendor/addressable/tasks/clobber.rake
    vendor/addressable/tasks/gem.rake
    vendor/addressable/tasks/git.rake
    vendor/addressable/tasks/metrics.rake
    vendor/addressable/tasks/rdoc.rake
    vendor/addressable/tasks/rubyforge.rake
    vendor/addressable/tasks/spec.rake
    vendor/addressable/website/index.html
  )

  s.test_files = s.files.select { |path| path =~ /^(test|spec)/ }
  s.add_dependency('rest-client', ['> 0.0.0'])
end
