Couchy: There Are Many Like It but This One is Mine
===================================================

Couchy is a simple, no-frills, Ruby wrapper around [CouchDB][]'s RESTFul API.

Quick overview
--------------

    server = CouchRest.new
    database = server.database('articles')
    response = database.save(:title => 'Atom-Powered Robots Run Amok', :content => 'Some text.')
    document = database.get(response['id'])
    database.delete(document)
    puts document.inspect

Requirements
------------

The fellowing gems are required:

- `rest-client`

To run the test and generate the code coverage report, you also need :

- `test/spec`
- `mocha`
- `rcov`
- `rspec`, for the legacy tests

and `yard` to generate the documentation.

Acknowledgement
---------------

It started as an Hardcore Forking Action of [jchris's CouchRest][original]
I ended up:

- Writing more tests. The legacy tests are rather integration tests while those
  I wrote are unit tests.
- DRY-ing it up
- Writing some documentation using [YARD][]

Unfortunately, jchris didn't merge the changes for some reasons.

Thank a lot to him for having written CouchRest in the first place and having
allowed me to relicense my fork under another license.

License
-------

(The MIT License)

Copyright (c) 2008 [Simon Rozet][sr], <simon@rozet.name>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[CouchDB]: http://couchdb.org
[original]: http://github.com/jchris/couchrest
[YARD]: http://yard.soen.ca/
[sr]: http://purl.org/net/sr/
