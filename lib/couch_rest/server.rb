module CouchRest
  class Server
    attr_accessor :uri

    def initialize(server='http://localhost:5984')
      @uri = server
    end
  
    # list all databases on the server
    def databases
      CouchRest.get "#{@uri}/_all_dbs"
    end
  
    def database(name)
      CouchRest::Database.new(@uri, name)
    end
  
    # create a database
    def create_db(name)
      CouchRest.put "#{@uri}/#{name}"
      database name
    end

    # get the welcome message
    def info
      CouchRest.get "#{@uri}/"
    end

    # restart the couchdb instance
    def restart!
      CouchRest.post "#{@uri}/_restart"
    end
  end
end
