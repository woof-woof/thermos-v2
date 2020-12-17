dofile('config.lua')

-- WiFi
wifi.setmode(wifi.STATION)
wifi.sta.setip({
    ip = NET_IP,
    netmask = NET_MASK,
    gateway = NET_GATEWAY
})
wifi.sta.config({
    ssid = WIFI_SSID,
    pwd = WIFI_PASSWORD
})

-- GPIO
gpio.mode(RELAY_PIN, gpio.OUTPUT)
gpio.write(RELAY_PIN, RELAY_OFF)

-- Reporting
function SendStatus(sck, status)
    htmlstring = '{"status": '..status..'}\n'
    sck:send(htmlstring)
end


-- ROUTER
function handler(sck, data)
    if string.find(data, "/status/on") then
        gpio.write(RELAY_PIN, RELAY_ON)
        SendStatus(sck, 1)
    elseif string.find(data, "/status/off") then
        gpio.write(RELAY_PIN, RELAY_OFF)
        SendStatus(sck, 0)
    elseif string.find(data, "GET /status") then
        status = gpio.read(RELAY_PIN)
        if (status == RELAY_ON) then
            status = 1
        else
            status = 0
        end
        SendStatus(sck, status)
    else
        sck:send('{"error": "Unknown path"}')
    end;
    
    sck:on("sent", function(conn) conn:close() end)
end


-- SERVER
server = net.createServer()
if server then
    server:listen(80,function(conn)
        conn:on("receive", handler)
    end)
end
