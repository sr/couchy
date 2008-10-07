require File.dirname(__FILE__) + '/test_helper'

describe 'Couchy#new' do
  it 'creates a new Server with the given server URI' do
    Couchy::Server.expects(:new).with('uri')
    Couchy.new('uri')
  end

  specify 'uri default to http://localhost:5984/' do
    server = Couchy.new
    server.uri.to_s.should.equal 'http://localhost:5984/'
  end
end
