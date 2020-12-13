-- load config file
dofile("config.lua")

-- setup wifi
dofile("setup_wifi.lua")

function startup()
    -- check for init.lua (does this make sense?)
    if file.open("init.lua") == nil then
        print("init.lua deleted or renamed")
        return
    end

    -- run remote deploy service
    ok, err = pcall(dofile, "deploy.lua")
    if not ok then
      print("deploy.lua failed with error: "  .. err)
    else
      print("running deploy.lua")
    end

    print("running...")
    file.close("init.lua")
    -- the actual application is stored in 'app.lua'
    -- dofile("deploy.lua")
    dofile("app.lua")
end

wifi_got_ip_event = function(T)
  -- Note: Having an IP address does not mean there is internet access!
  -- Internet connectivity can be determined with net.dns.resolve().
  print("wifi connection is ready -> IPAddr="..T.IP)
  print("startup will resume momentarily, you have 1 second to abort")
  print("waiting...")
  tmr.create():alarm(1000, tmr.ALARM_SINGLE, startup)
end

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)