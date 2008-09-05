require 'rubygems'
require 'json'
require 'rest_client'
require 'addressable/uri'

$:.unshift File.dirname(__FILE__) + '/couch_rest'

require 'core_ext'

module CouchRest
  autoload :Server,       'server'
  autoload :Database,     'database'
  autoload :Pager,        'pager'
  autoload :FileManager,  'file_manager'

  def self.new(server_uri)
    Server.new(server_uri)
  end
end
