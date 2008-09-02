require File.dirname(__FILE__) + '/test_helper'

describe 'Server' do
  specify 'server uri default to http://localhost:5984' do
    server = CouchRest::Server.new
    server.server_uri.should.equal 'http://localhost:5984'
  end

  it 'has an accessor on the server uri' do
    server = CouchRest::Server.new('foo')
    server.server_uri.should.equal 'foo'
  end

  describe 'HTTP requests' do
    setup do
      @server = CouchRest::Server.new
    end

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
  end
end
