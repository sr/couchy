describe 'CouchRest#new' do
  it 'creates a new Server with the given server URI' do
    CouchRest::Server.expects(:new).with('uri')
    CouchRest.new('uri')
  end
end
