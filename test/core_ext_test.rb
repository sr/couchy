require File.dirname(__FILE__) + '/test_helper'

require File.dirname(__FILE__) + '/../lib/couch_rest/core_ext'

describe 'String#to_uri' do
  it 'accepts an hash of parameters and append them to the URI as the query_string' do
    'http://foo.org/'.to_uri(:nas => 'legend', :mobb => 'deep').to_s.should.
      equal 'http://foo.org/?nas=legend&mobb=deep'
  end

  it 'accepts a path and join it to the URI' do
    'http://rozet.name'.to_uri('simon').to_s.should.equal 'http://rozet.name/simon'
  end

  it 'accepts both a path and an Hash of parameters' do
    'http://abc.org'.to_uri('def', :a => 'b', :c => 'd').to_s.should.
      equal 'http://abc.org/def?a=b&c=d'
  end
end
