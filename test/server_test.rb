require File.dirname(__FILE__) + '/test_helper'

describe 'Server' do
  setup do
    @server = CouchRest::Server.new
  end

  specify 'uri default to http://localhost:5984' do
    server = CouchRest::Server.new
    server.uri.to_s.should.equal 'http://localhost:5984'
  end

  it 'has an accessor on its uri' do
    server = CouchRest::Server.new('foo')
    server.uri.to_s.should.equal 'foo'
  end

  describe '#json' do
    it 'parse the given json with the given options' do
      JSON.expects(:parse).with('foo', :bar => :spam)
      @server.json('foo', :bar => :spam)
    end
  end

  describe 'HTTP requests' do
    describe 'GET' do
      it 'prepends server URI to given path' do
        @server.stubs(:json).returns('')
        RestClient.expects(:get).with('http://localhost:5984/foo/bar')
        @server.get('foo/bar')
      end

      it 'appends params as query string' do
        @server.stubs(:json)
        RestClient.expects(:get).with('http://localhost:5984/foo?bar=spam')
        @server.get('foo', :bar => 'spam')
      end

      it 'parse the result as json with :max_nesting set to false' do
        RestClient.expects(:get).returns('some json')
        @server.expects(:json).with('some json', :max_nesting => false).returns('some json')
        @server.get('give_me_some_json')
      end

      it 'do not parse the result as json if :no_json is specified' do
        RestClient.stubs(:get).returns('foo')
        @server.expects(:json).with('foo', anything).never
        @server.get('bar', :no_json => true)
      end
    end

    describe 'POST' do
      it 'prepends server URI to given path' do
        @server.stubs(:json).returns('')
        RestClient.expects(:post).with('http://localhost:5984/a/b', nil, nil)
        @server.post('a/b')
      end

      it 'appends given parameters as the query string of the URI' do
        @server.stubs(:json).returns('')
        RestClient.expects(:post).with('http://localhost:5984/foo?bar=spam', nil, nil)
        @server.post('foo', nil, :bar => 'spam')
      end

      it 'jsonify and post the given document' do
        doc = {:foo => 'bar'}
        @server.stubs(:json).returns('')
        doc.expects(:to_json).returns('some json')
        RestClient.expects(:post).with('http://localhost:5984/foo', 'some json', nil).
          returns([:a,:b].to_json)
        @server.post('foo', doc)
      end

      it 'passes given headers to RestClient' do
        @server.stubs(:json).returns('')
        RestClient.expects(:post).with(anything, anything, {'Content-Type' => 'application/json'})
        @server.post('foo', nil, :headers => {'Content-Type' => 'application/json'})
      end
    end

    describe 'PUT' do
      it 'prepends server URI to given path' do
        @server.stubs(:json).returns('')
        RestClient.expects(:put).with('http://localhost:5984/a/b', nil, nil)
        @server.put('a/b')
      end

      it 'jsonify and post the given document' do
        @server.stubs(:json)
        doc = {:foo => 'bar'}
        doc.expects(:to_json).returns('some json')
        RestClient.expects(:put).with('http://localhost:5984/foo', 'some json')
        @server.put('foo', doc)
      end
    end

    describe 'DELETE' do
      it 'prepends server URI to given path' do
        @server.stubs(:json).returns('')
        RestClient.expects(:delete).with('http://localhost:5984/a/b', nil, nil)
        @server.delete('a/b')
      end
    end
  end

  describe 'Getting a list of all the databases' do
    it 'GET _all_dbs' do
      @server.expects(:get).with('_all_dbs')
      @server.databases
    end
  end

  describe 'Getting a database' do
    it 'creates a new Database object with the given name and itselfs' do
      CouchRest::Database.expects(:new).with(@server, 'mydb')
      @server.database('mydb')
    end

    it 'returns a Database' do
      @server.database('mydb').should.be.an.instance_of CouchRest::Database
    end
  end

  describe 'Getting info on the server' do
    it 'GET the server URI' do
      @server.expects(:get).with('/')
      @server.info
    end
  end

  describe 'Restarting the server' do
    it 'POST _restart' do
      @server.expects(:post).with('_restart')
      @server.restart!
    end
  end

  describe 'Creating a new database' do
    it 'PUT to database_name' do
      @server.expects(:put).with('mydb')
      @server.create_db('mydb')
    end

    it 'returns a Database' do
      @server.stubs(:put)
      @server.create_db('mydb').should.be.an.instance_of CouchRest::Database
    end
  end
end
