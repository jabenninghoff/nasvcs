GET http://nasvcs.test/viewvc
HTTP 301

GET http://nasvcs.test/viewvc/
HTTP 200

GET http://nasvcs.test/viewvc.cgi
HTTP 404

GET http://nasvcs.test/viewvc/iis/
HTTP 404

GET http://nasvcs.test/viewvc/iis/viewvc
HTTP 404

GET http://nasvcs.test/viewvc/iis/viewvc.cgi
HTTP 404
