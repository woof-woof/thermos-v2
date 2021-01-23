dofile('power_reading.lua')

SECOND = 1000000
headers = 'Content-Type: application/json\r\n'

function dsleep(seconds)
	print("Going to sleep for " .. seconds .. " seconds...")
	node.dsleep(seconds * SECOND)
end

function requestCallback(code, data)
	if (code < 0) then
		print("HTTP request failed")
	else
		print(code, data)
	end

	dsleep(SLEEP_SECONDS)
end



-- power on sensor, wait for setup, read, power off
gpio.mode(DHT_POWER_PIN, gpio.OUTPUT)
gpio.write(DHT_POWER_PIN, gpio.HIGH)
tmr.delay(SECOND)
print ('[reading DHT11 on pin ' .. DHT_READ_PIN .. ']')
status, temp, humi, temp_dec, humi_dec = dht.read(DHT_READ_PIN)
gpio.write(DHT_POWER_PIN, gpio.LOW)

voltage = read_voltage and read_voltage () or -1
print ('[got temp:', temp, ' humi:', humi, 'voltage:', voltage, ']')

-- @TODO add retry
body = sjson.encode({id=SENSOR_ID, temp=temp, humi=humi, voltage=voltage})
http.post(SERVER_ADDR, headers, body, requestCallback)