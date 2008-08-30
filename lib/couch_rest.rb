require 'rubygems'
require 'json'
require 'rest_client'

$:.unshift File.dirname(__FILE__) + '/couch_rest'

module CouchRest
  autoload :Server,       'server'
  autoload :Database,     'database'
  autoload :Pager,        'pager'
  autoload :FileManager,  'file_manager'

  module_function

    def new(uri='http://localhost:5984')
      Server.new(uri)
    end

    def put(uri, doc=nil)
      payload = doc.to_json if doc
      json RestClient.put(uri, payload)
    end
  
    def get(uri)
      json(RestClient.get(uri), :max_nesting => false)
    end
    
    def post(uri, doc=nil)
      payload = doc.to_json if doc
      json RestClient.post(uri, payload)
    end
    
    def delete(uri)
      json RestClient.delete(uri)
    end
    
    def paramify_url(url, params=nil)
      if params
        query = params.collect do |k,v|
          v = v.to_json if %w{key startkey endkey}.include?(k.to_s)
          "#{k}=#{CGI.escape(v.to_s)}"
        end.join("&")
        url = "#{url}?#{query}"
      end
      url
    end

    def json(json_string, options={})
      JSON.parse(json_string, options)
    end
end
