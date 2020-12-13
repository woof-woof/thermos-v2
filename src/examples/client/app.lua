SECOND = 1000000

uri = 'http://192.168.0.101:3000/reading'
headers = 'Content-Type: application/json\r\n'

function dsleep(seconds)
	print("Going to sleep for " .. seconds .. " seconds...")
	node.dsleep(seconds * SECOND)
end

function callback(code, data)
	if (code < 0) then
		print("HTTP request failed")
	else
		print(code, data)
	end

	dsleep(3)
end

function startup()
	print ('[startup]')
	
	print ('[reading DHT11 on pin ' .. DHT_PIN .. ']')
	print ('[reading DHT11 on pin ' .. DHT_PIN .. ']...')
	status, temp, humi, temp_dec, humi_dec = dht.read(DHT_PIN)
	print ('[got temp:' .. temp ' humi:' .. humi .. ']')
	body = sjson.encode({temp=temp, humi=humi})
	http.post(uri, headers, body, callback)
end

-- TODO add retry
print("good morning :)")
tmr.create():alarm(4000, tmr.ALARM_SINGLE, startup)