require File.dirname(__FILE__) + '/test_helper'

describe 'Database' do
  before(:each) do
    @server = stub('server', :get => '', :post => '', :put => '', :delete => '')
    @database = CouchRest::Database.new(@server, TestDatabase)
  end

  it 'has an accessor to the database name' do
    @database.name.should.equal TestDatabase
  end

  it 'has an accessor to the server instance' do
    @database.server.should.equal @server
  end

  describe 'Getting a list of documents' do
    it 'GET name/_all_docs' do
      @server.expects(:get).with(TestDatabase + '/_all_docs', {})
      @database.documents
    end

    it 'passes params around if necessary' do
      @server.expects(:get).with(TestDatabase + '/_all_docs', :startkey => 'somedoc', :count => 3)
      @database.documents(:startkey => 'somedoc', :count => 3)
    end
  end

  describe 'Creating a temporary view' do
    it 'POST name/_temp_view with given fonction' do
      @server.expects(:post).with(TestDatabase + '/_temp_view', 'function(doc){emit(null, doc);}', anything)
      @database.temp_view('function(doc){emit(null, doc);}')
    end

    it 'passes parameters around if necessary' do
      @server.expects(:post).with(anything, 'foo', has_entries(:startkey => 'foo'))
      @database.temp_view('foo', :startkey => 'foo')
    end

    it 'POST with application/json Content-Type' do
      @server.expects(:post).with(anything, anything,
        has_entries(:headers => {'Content-Type' => 'application/json'}))
      @database.temp_view('foo')
    end
  end

  describe 'Getting a view' do
    it 'GET name/_view/view_name' do
      @server.expects(:get).with("#{TestDatabase}/_view/my-view", {})
      @database.view('my-view')
    end

    it 'passes parameters around if necessary' do
      @server.expects(:get).with(anything, :count => 100)
      @database.view('my-view', :count => 100)
    end
  end

  describe 'Issuing a search' do
  end

  describe 'Issuing an action' do
  end
end
