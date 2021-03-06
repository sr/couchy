module Couchy
  class Server
    attr_accessor :uri

    def initialize(uri)
      @uri = Addressable::URI.parse(uri)
    end

    # Gets information about the server
    #
    # @return [Hash] Parsed server response
    def info
      get '/'
    end

    # Restarts the server
    #
    # @return [Hash] Parsed server response
    def restart!
      post '_restart'
    end

    # Gets a list of all the databases available on the server
    #
    # @return [Array] Parsed server response
    def databases
      get '_all_dbs'
    end
  
    # Gets a new [Couchy::Database] for the database
    #
    # @param [String] name The name of the database
    #
    # @return [Couchy::Database] The database
    def database(name)
      Database.new(self, name)
    end
  
    # Creates a database
    #
    # @param [String] name Database's name
    #
    # @return [Couchy::Database] The newly created database
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

    def delete(path, params={})
      json RestClient.delete(uri_for(path, params))
    end

    private
      def uri_for(path, params={})
        u = uri.join(path)
        u.query_values = stringify_keys_and_jsonify_values(params) if params.any?
        u.to_s
      end

      def json(json_string, options={})
        JSON.parse(json_string, options)
      end

      def stringify_keys_and_jsonify_values(hash)
        hash.inject({}) do |memo, (key, value)|
          value = value.to_json if %w(key startkey endkey).include?(key.to_s)
          memo[key.to_s] = value.to_s
          memo
        end
      end
  end
end
