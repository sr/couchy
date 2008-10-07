require 'rubygems'
require 'json'
require 'rest_client'
require 'addressable/uri'

$:.unshift File.dirname(__FILE__) + '/couchy'

module Couchy
  autoload :Server,       'server'
  autoload :Database,     'database'

  # Shortcut for Couchy::Server.new
  #
  # @param [String] server_uri The URI of the CouchDB server. defaults to "http://localhost:5984/"
  # @return Couchy::Server
  def self.new(server_uri='http://localhost:5984/')
    Server.new(server_uri)
  end
end