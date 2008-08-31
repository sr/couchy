require 'cgi'
require 'base64'

module CouchRest
  class Database
    attr_accessor :server, :name

    def initialize(server, database_name)
      @name = database_name
      @server = server
    end
    
    def documents(params={})
      server.get("#{name}/_all_docs", params)
    end
  
    def temp_view(function, params={})
      server.post("#{name}/_temp_view", params, function, {'Content-Type' => 'application/json'})
    end
  
    def view(view_name, params={})
      server.get("#{name}/_view/#{view_name}", params)
    end

    def search(params={})
      server.get(URI.join(name, '_search'), params)
    end

    def action(action, params={})
      server.get(URI.join(name, '_action', action), params)
    end
    
    def get(id)
      server.get("/#{name}/#{CGI.escape(id)}")
    end
    
    def fetch_attachment(document_id, attachment_name)
      server.get("#{name}/#{CGI.escape(document_id)}/#{CGI.escape(attachment_name)}", :no_json => true)
    end
    
    def save(doc)
      if doc['_attachments']
        doc['_attachments'] = encode_attachments(doc['_attachments'])
      end
      if doc['_id']
        server.put("/#{name}/#{CGI.escape(doc['_id'])}", doc)
      else
        server.post("/#{name}", {}, doc)
      end
    end
    
    def bulk_save(docs)
      server.post("#{name}/_bulk_docs", {}, {:docs => docs})
    end
    
    def delete(doc)
      server.delete "#{name}/#{CGI.escape(doc['_id'])}?rev=#{doc['_rev']}"
    end
    
    def delete!
      server.delete(name)
    end

    private
      def encode_attachments(attachments)
        attachments.each do |k,v|
          next if v['stub']
          v['data'] = base64(v['data'])
        end
        attachments
      end

      def base64(data)
        Base64.encode64(data).gsub(/\s/,'')
      end
  end
end
