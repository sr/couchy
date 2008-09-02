module CouchRest
  class Server
    attr_accessor :server_uri

    def initialize(server='http://localhost:5984')
      @server_uri = server
    end

    # list all databases on the server
    def databases
      get('_all_dbs')
    end
  
    def database(name)
      Database.new(self, name)
    end
  
    # create a database
    def create_db(name)
      put(name)
      database(name)
    end

    # get the welcome message
    def info
      get "#{@uri}/"
    end

    # restart the couchdb instance
    def restart!
      post "#{@uri}/_restart", {}
    end

    def get(path, params={})
      need_json = !params.delete(:no_json)
      response = RestClient.get(server_uri.to_uri(path, params).to_s)
      need_json ? json(response, :max_nesting => false) : response
    end

    def put(uri, doc=nil)
      payload = doc.to_json if doc
      json RestClient.put(URI.join(server_uri, uri).to_s, payload)
    end

    def post(path, doc=nil, params={})
      headers = params.delete(:headers)
      payload = doc.to_json if doc
      json(RestClient.post(server_uri.to_uri(path, params).to_s, payload, headers))
    end

    def delete(uri)
      json RestClient.delete(URI.join(server_uri, uri).to_s)
    end

    def json(json_string, options={})
      JSON.parse(json_string, options)
    end

    def paramify_url(url, params = nil)
      if params
        query = params.collect do |k,v|
          v = v.to_json if %w{key startkey endkey}.include?(k.to_s)
          "#{k}=#{CGI.escape(v.to_s)}"
        end.join("&")
        url = "#{url}?#{query}"
      end
      url
    end
  end
end
