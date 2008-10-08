require 'cgi'
require 'base64'

module Couchy
  class Database
    attr_accessor :server, :name

    def initialize(server, database_name)
      @name = database_name
      @server = server
    end
    
    # Gets a list of all the documents available in the database
    #
    # @param [Hash] params
    #
    # @return [Hash] Parsed server response
    def documents(params={})
      server.get("#{name}/_all_docs", params)
    end
  
    # Creates a temporary view
    #
    # @param [String] function The view function
    # @param [Hash] params
    #
    # @return [Hash] Parsed server response
    def temp_view(function, params={})
      server.post("#{name}/_temp_view", function,
        params.merge!(:headers => {'Content-Type' => 'application/json'}))
    end
  
    # Query a view
    #
    # @param [String] view_name The name of the view
    # @param [Hash] params
    #
    # @return [Hash] Parsed server response
    def view(view_name, params={})
      server.get("#{name}/_view/#{view_name}", params)
    end

    # Retrieves a document by its ID
    #
    # @param [String] id The ID of the document
    #
    # @return [Hash] Parsed server response
    def get(id)
      server.get("#{name}/#{CGI.escape(id)}")
    end
    
    # Retrieves an attachment from a document
    #
    # @param [String] document_id The ID of the document
    # @param [String] attachment_name The name of the attachment
    #
    # @return [Hash] Parsed server response
    def fetch_attachment(document_id, attachment_name)
      server.get("#{name}/#{CGI.escape(document_id)}/#{CGI.escape(attachment_name)}", :no_json => true)
    end
    
    # Saves or updates a document
    #
    # @param [Hash] doc The document
    #
    # @return [Hash] Parsed server response
    def save(doc)
      doc = encode_attachments_of(doc)

      if doc['_id']
        server.put("#{name}/#{CGI.escape(doc['_id'])}", doc)
      else
        server.post("#{name}", doc)
      end
    end
    
    # Saves or updates a bunch of documents
    #
    # @param [Array] docs The documents to save
    #
    # @return [Hash] Parsed server response
    def bulk_save(docs)
      server.post("#{name}/_bulk_docs", {:docs => docs})
    end
    
    # Deletes a document
    #
    # @param [String, Hash] document Document ID or an Hash representing the document
    # @param [String] revision Document's revision
    #
    # @raise ArgumentError When the Hash representing the document neither has
    #                      an ID nor a revision
    #
    # @raise ArgumentError When document is neither an ID nor an Hash
    #                      representing a document
    #
    # @return [Hash] Parsed server response
    def delete(document, revision=nil)
      case document
      when String
        raise ArgumentError unless revision
        server.delete "#{name}/#{CGI.escape(document)}", :rev => revision
      when Hash
        raise ArgumentError unless document['_id'] && document['_rev']
        server.delete("#{name}/#{CGI.escape(document['_id'])}", :rev => document['_rev'])
      else
        raise ArgumentError
      end
    end
    
    # Deletes the current database
    #
    # @return [Hash] Parsed server response
    def delete!
      server.delete(name)
    end

    private
      def encode_attachments_of(doc)
        return doc unless doc['_attachments']
        doc['_attachments'].each { |_, v| v.update('data' => base64(v['data'])) } and doc
      end

      def base64(data)
        Base64.encode64(data.to_s).gsub(/\s/,'')
      end
  end
end
