wifiSSID = "..."
wifiPass = "..."

wifi.setmode(wifi.STATION)
wifi.sta.config(wifiSSID, wifiPass)
print(wifi.sta.getip())
glob_last_temp = "<<undefined>>"
tmr.alarm(0, 15000, 1, function() dofile("heartbeat.lua") end ) -- poll weather every minute

-- and run server
srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
		conn:on("receive",function(conn,payload)
			--print(payload) 
			conn:send("<h1>Last checked temperature is "..glob_last_temp.."&deg;C</h1>"..
			"This node gets its data from api.openweathermap.org, then sends the temperature update to api.thingspeak.com and the vera (assuming it's at <a href=\"http://192.168.0.80/\">192.168.0.80</a>)")
			conn:close()
		end) 
	end)