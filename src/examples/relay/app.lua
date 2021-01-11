dofile('httpserver.lua')

-- GPIO
gpio.mode(RELAY_PIN, gpio.OUTPUT)
gpio.write(RELAY_PIN, RELAY_OFF)

-- SERVER
print("http server listening on port 80...")
httpServer:listen(80)

-- ROUTER
httpServer:use('/', function(req, res)
	res:type('application/json')
    res:status('200 OK')
    status = gpio.read(RELAY_PIN)
        if (status == RELAY_ON) then
            status = 1
        else
            status = 0
        end
	res:send('{"state": '..status..'}')
end)

httpServer:use('/on', function(req, res)
    res:type('application/json')
    res:status('200 OK')
    gpio.write(RELAY_PIN, RELAY_ON)
    res:send('{"state": 1}')
end)

httpServer:use('/off', function(req, res)
	res:type('application/json')
    res:status('200 OK')
    gpio.write(RELAY_PIN, RELAY_OFF)
	res:send('{"state": 0}')
end)


