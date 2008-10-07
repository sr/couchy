Gem::Specification.new do |s|
  s.name     = 'couchy'
  s.version  = '0.0.1'
  s.date     = '2008-10-07'
  s.summary  = 'Simple, no-frills, Ruby wrapper around the nice CouchDB HTTP API'
  s.description = 'Simple, no-frills, Ruby wrapper around the nice CouchDB HTTP API'
  s.homepage = 'http://github.com/sr/couchy'
  s.email    = 'simon@rozet.name'
  s.authors  = ['Simon Rozet']
  s.has_rdoc = false
  s.files    = ['README.textile',
    'Rakefile',
    'lib/couchy.rb',
    'lib/couchy/database.rb',
    'lib/couchy/server.rb'
  ]
  s.test_files = ['spec/couchy_spec.rb',
    'spec/database_spec.rb',
    'spec/fixtures/attachments/test.html',
    'spec/fixtures/views/lib.js',
    'spec/fixtures/views/test_view/lib.js',
    'spec/fixtures/views/test_view/only-map.js',
    'spec/fixtures/views/test_view/test-map.js',
    'spec/fixtures/views/test_view/test-reduce.js',
    'spec/spec.opts',
    'spec/spec_helper.rb',
    'test/couchy_test.rb',
    'test/database_test.rb',
    'test/server_test.rb',
    'test/test_helper.rb'
  ]
  s.add_dependency('rest-client', ['> 0.0.0'])
  s.add_dependency('addressable', ['> 0.0.0'])
end
