SECOND = 1000000
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

	dsleep(SLEEP_SECONDS)
end

print("good morning :)")
print ('[reading DHT11 on pin ' .. DHT_PIN .. ']')
status, temp, humi, temp_dec, humi_dec = dht.read(DHT_PIN)
print ('[got temp:', temp, ' humi:', humi, ']')

-- TODO add retry
body = sjson.encode({temp=temp, humi=humi})
http.post(SERVER_ADDR, headers, body, callback)