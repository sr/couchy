module CouchRest
  class Server
    attr_accessor :uri

    def initialize(uri)
      @uri = Addressable::URI.parse(uri)
    end

    def info
      get '/'
    end

    def restart!
      post '_restart'
    end

    def databases
      get '_all_dbs'
    end
  
    def database(name)
      Database.new(self, name)
    end
  
    def create_db(name)
      put(name)
      database(name)
    end

    def get(path, params={})
      need_json = !params.delete(:no_json)
      response = RestClient.get(uri_for(path, params))
      need_json ? json(response, :max_nesting => false) : response
    end

    def post(path, doc=nil, params={})
      headers = params.delete(:headers)
      payload = doc.to_json if doc
      json RestClient.post(uri_for(path, params), payload, headers)
    end

    def put(path, doc=nil)
      payload = doc.to_json if doc
      json RestClient.put(uri_for(path), payload)
    end

    def delete(path)
      json RestClient.delete(uri_for(path))
    end

    private
      def uri_for(path, params={})
        uri.join(path).tap do |uri|
          uri.query_values = params.stringify_keys_and_jsonify_values! if params.any?
        end.to_s
      end

      def json(json_string, options={})
        JSON.parse(json_string, options)
      end
  end
end
