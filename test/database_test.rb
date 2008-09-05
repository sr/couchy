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

  describe 'Getting a document' do
    it 'GET name/id' do
      @server.expects(:get).with("#{TestDatabase}/foobar")
      @database.get('foobar')
    end

    it 'should encode the document id' do
      CGI.expects(:escape).with('foobar')
      @database.get('foobar')
    end
  end

  describe 'Fetching an attachment' do
    it 'GET name/document_id/attachment_id' do
      @server.expects(:get).with("#{TestDatabase}/my-doc/foo", anything)
      @database.fetch_attachment('my-doc', 'foo')
    end

    it 'encodes the document id and the attachement id' do
      CGI.expects(:escape).with('my-doc')
      CGI.expects(:escape).with('foo')
      @database.fetch_attachment('my-doc', 'foo')
    end
  end

  describe 'Saving a document' do
    # TODO: stringify_keys! to accept symbol keys

    it 'encodes the attachments if the doc contains the key _attachments' do
      doc = {'_attachments' => 'foo'}
      @database.expects(:encode_attachments).with(doc['_attachments']).returns('bar')
      doc.expects(:[]=).with('_attachments', 'bar')
      @database.save(doc)
    end

    it 'POST the document to database_name when no id specified' do
      doc = {:foo => 'bar'}
      @server.expects(:post).with(TestDatabase, doc)
      @database.save(doc)
    end

    describe 'When a document id is specified' do
      it 'PUT the document to database_name/document_id' do
        doc = {'_id' => 'mydocid', 'foo' => 'bar'}
        @server.expects(:put).with("#{TestDatabase}/#{doc['_id']}", doc)
        @database.save(doc)
      end

      it 'encodes the given document id' do
        CGI.expects(:escape).with('mydocid')
        @database.save('_id' => 'mydocid')
      end
    end
  end

  describe 'Bulk saving a bunch of documents' do
    it 'POST the documents to database_name/_bulk_docs' do
      @server.expects(:post).with("#{TestDatabase}/_bulk_docs", :docs => ['foo', 'bar'])
      @database.bulk_save(['foo', 'bar'])
    end
  end

  describe 'Deleting a document' do
    describe 'When given the document id' do
      it 'DELETE database_name/document_id' do
        @server.expects(:delete).with("#{TestDatabase}/mydocid")
        @database.delete('mydocid')
      end

      it 'encodes the given document id' do
        CGI.expects(:escape).with('mydocid')
        @database.delete('mydocid')
      end
    end

    describe 'When given an Hash representing a document' do
      it 'raises ArgumentError if it do not have an _id key' do
        proc do
          @database.delete('foo' => 'bar')
        end.should.raise(ArgumentError)
      end

      it 'DELETE database_name/document_id' do
        @server.expects(:delete).with("#{TestDatabase}/mydocid")
        @database.delete('_id' => 'mydocid')
      end

      it 'encodes the given document id' do
        CGI.expects(:escape).with('mydocid')
        @database.delete('_id' => 'mydocid')
      end

      it 'DELETE database_name/document_id?rev=revision_id' do
        @server.expects(:delete).with("#{TestDatabase}/mydocid?rev=34")
        @database.delete('_id' => 'mydocid', '_rev' => 34)
      end
    end

    it 'raises ArgumentError if the given argument is neither a document id nor a document' do
      proc do
        @database.delete(:fooo)
      end.should.raise(ArgumentError)
    end
  end

  describe 'Deleting the database' do
    it 'DELETE database_name' do
      @server.expects(:delete).with(TestDatabase)
      @database.delete!
    end
  end
end
