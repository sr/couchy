require 'rubygems'
require 'json'
require 'rest_client'

$:.unshift File.dirname(__FILE__) + '/couch_rest'

module CouchRest
  autoload :Server,       'server'
  autoload :Database,     'database'
  autoload :Pager,        'pager'
  autoload :FileManager,  'file_manager'

  def self.new(uri='http://localhost:5984')
    Server.new(uri)
  end
end
