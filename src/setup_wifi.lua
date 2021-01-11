-- Define WiFi station event callbacks
wifi_connect_event = function(T)
  print("Connection to AP("..T.SSID..") established!")
  print("Waiting for IP address...")
end

-- Register WiFi Station event callbacks
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)

print("Connecting to WiFi access point...")
wifi.setmode(wifi.STATION)
wifi.sta.config({ssid=WIFI_SSID, pwd=WIFI_PASSWORD})

-- Static IP, connects faster
if (NET_IP) then
  wifi.sta.setip({
      ip = NET_IP,
      netmask = NET_MASK,
      gateway = NET_GATEWAY
  })
end