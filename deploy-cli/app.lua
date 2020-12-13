dofile('httpserver.lua')
httpServer:listen(80)

httpServer:use('/', function(req, res)
	res:type('application/json')
	res:status('200 OK')
	res:send(sjson.encode({success=true}))
end)
