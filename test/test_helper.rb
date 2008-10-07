require 'rubygems'
require 'test/spec'
require 'mocha'

require File.dirname(__FILE__) + '/../lib/couchy'

begin
  CouchHost     = 'http://0.0.0.0:5984'
  TestDatabase  = 'couchy-test'
end unless defined?(CouchHost)
