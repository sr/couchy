require File.dirname(__FILE__) + '/test_helper'

describe 'Database' do
  before(:each) do
    @server = stub('server', :get => '', :post => '', :put => '', :delete => '')
    @database = Couchy::Database.new(@server, TestDatabase)
  end

  it 'has an accessor on its name' do
    @database.name.should.equal TestDatabase
  end

  it 'has an accessor on the server instance' do
    @database.server.should.equal @server
  end

  specify '#base64 removes new lines to workaround <https://issues.apache.org/jira/browse/COUCHDB-19>' do
    @database.send(:base64, 'foo').should.equal 'Zm9v'
  end

  describe 'Encoding attachments of a document' do
    setup do
      Couchy::Database.class_eval { public :encode_attachments_of }
      @server.stubs(:base64).returns('')
      @database = Couchy::Database.new(@server, TestDatabase)
      @attachments = { 'foo' => { 'type' => 'text/plain', 'data' => 'some text' },
                       'bar' => { 'type' => 'text/plain', 'data' => 'same here' }}
      @doc = {:foo => 'bar', '_attachments' => @attachments}
    end

    it 'returns the doc as is if there is no attachment' do
      @database.encode_attachments_of(:foo => 'bar').should.equal(:foo => 'bar')
    end

    it 'encodes the data of each attachment in base64' do
      @database.expects(:base64).with('some text').returns('')
      @database.expects(:base64).with('same here').returns('')
      @database.encode_attachments_of(@doc)
    end

    it 'returns the document with the attachments encoded' do
      doc = @database.encode_attachments_of(@doc)
      doc['_attachments']['foo']['data'].should.equal 'c29tZSB0ZXh0'
      doc['_attachments']['bar']['data'].should.equal 'c2FtZSBoZXJl'
    end
  end

  describe 'Deleting itselfs' do
    it 'DELETE $database_name' do
      @server.expects(:delete).with(TestDatabase)
      @database.delete!
    end
  end

  describe 'Getting a list of documents' do
    it 'GET $database_name/_all_docs' do
      @server.expects(:get).with(TestDatabase + '/_all_docs', {})
      @database.documents
    end

    it 'uses given parameters' do
      @server.expects(:get).with(TestDatabase + '/_all_docs', :startkey => 'somedoc', :count => 3)
      @database.documents(:startkey => 'somedoc', :count => 3)
    end
  end

  describe 'Getting a document' do
    it 'GET $database_name/$document_id' do
      @server.expects(:get).with("#{TestDatabase}/foobar")
      @database.get('foobar')
    end

    it 'escapes the given document id' do
      CGI.expects(:escape).with('foobar')
      @database.get('foobar')
    end
  end

  describe 'Saving a document' do
    it 'encodes attachments of the given document' do
      doc = {:foo => 'bar'}
      @database.expects(:encode_attachments_of).with(doc).returns({})
      @database.save(doc)
    end

    it 'POST the document to $database_name when no document id is specified' do
      doc = {:foo => 'bar'}
      @server.expects(:post).with(TestDatabase, doc)
      @database.save(doc)
    end

    describe 'When a document id was specified' do
      it 'PUT the document to $database_name/$document_id' do
        doc = {'_id' => 'mydocid', 'foo' => 'bar'}
        @server.expects(:put).with("#{TestDatabase}/#{doc['_id']}", doc)
        @database.save(doc)
      end

      it 'escapes the given document id' do
        CGI.expects(:escape).with('mydocid')
        @database.save('_id' => 'mydocid')
      end
    end
  end

  describe 'Bulk saving a bunch of documents' do
    it 'POST the documents to $database_name/_bulk_docs' do
      @server.expects(:post).with("#{TestDatabase}/_bulk_docs", :docs => ['doc1', 'doc2'])
      @database.bulk_save(['doc1', 'doc2'])
    end
  end

  describe 'Fetching an attachment' do
    it 'GET $database_name/$document_id/$attachment_id' do
      @server.expects(:get).with("#{TestDatabase}/my-doc/foo", anything)
      @database.fetch_attachment('my-doc', 'foo')
    end

    it 'escapes the document id and the attachement id' do
      CGI.expects(:escape).with('my-doc')
      CGI.expects(:escape).with('foo')
      @database.fetch_attachment('my-doc', 'foo')
    end
  end

  describe 'Deleting a document' do
    describe 'When given the document id and the revision' do
      it 'DELETE $database_name/$document_id?rev=$revision' do
        @server.expects(:delete).with("#{TestDatabase}/mydocid", :rev => 2800624930)
        @database.delete('mydocid', 2800624930)
      end

      it 'escapes the document id' do
        CGI.expects(:escape).with('mydocid')
        @database.delete('mydocid', 2800624930)
      end
    end

    describe 'When given an Hash representing a document' do
      it 'raises ArgumentError if the doc doesnt have an _id' do
        lambda { @database.delete('foo' => 'bar') }.should.raise(ArgumentError)
      end

      it 'raises ArgumentError if the doc doesnt have a _rev' do
        lambda { @database.delete('_id' => 'foo') }.should.raise(ArgumentError)
      end

      it 'DELETE $database_name/$document_id?rev=$revision' do
        @server.expects(:delete).with("#{TestDatabase}/mydocid", :rev => 2800624930)
        @database.delete('_id' => 'mydocid', '_rev' => 2800624930)
      end

      it 'escapes the document id' do
        CGI.expects(:escape).with('mydocid')
        @database.delete('_id' => 'mydocid', '_rev' => 286633)
      end
    end

    it 'raises ArgumentError if the given argument is neither a document id nor a document' do
      lambda { @database.delete(:fooo) }.should.raise(ArgumentError)
    end
  end

  describe 'Creating a temporary view' do
    it 'POST $database_name/_temp_view with the given fonction' do
      @server.expects(:post).with(TestDatabase + '/_temp_view', 'js function', anything)
      @database.temp_view('js function')
    end

    it "sets the request's Content-Type to application/json" do
      @server.expects(:post).with(anything, anything,
        has_entries(:headers => {'Content-Type' => 'application/json'}))
      @database.temp_view('foo')
    end

    it 'uses the given parameters' do
      @server.expects(:post).with(anything, 'foo', has_entries(:startkey => 'foo'))
      @database.temp_view('foo', :startkey => 'foo')
    end
  end

  describe 'Getting a view' do
    it 'GET $database_name/_view/$view_name' do
      @server.expects(:get).with("#{TestDatabase}/_view/my-view", {})
      @database.view('my-view')
    end

    it 'uses the given parameters' do
      @server.expects(:get).with(anything, :count => 100)
      @database.view('my-view', :count => 100)
    end
  end
end
