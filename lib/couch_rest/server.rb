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

    def get(uri, params={})
      need_json = !params.delete(:no_json)
      uri = paramify_url(uri, params)
      response = RestClient.get(URI.join(server_uri, uri).to_s)
      need_json ? json(response, :max_nesting => false) : response
    end

    def put(uri, doc=nil)
      payload = doc.to_json if doc
      json RestClient.put(URI.join(server_uri, uri).to_s, payload)
    end

    def post(uri, params, *args)
      doc = args.first
      headers = args.last if args.length > 1
      uri = URI.join(server_uri, paramify_url(uri.to_s, params)).to_s
      payload = doc.to_json if doc
      json(RestClient.post(uri, payload, headers))
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
