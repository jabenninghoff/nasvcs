GET http://nasvcs.test
HTTP 403

GET http://nasvcs.test/gitweb
HTTP 301

GET http://nasvcs.test/gitweb/
HTTP 401

GET http://nasvcs.test/gitweb.cgi
HTTP 404

GET http://nasvcs.test/gitweb/static/
HTTP 401
