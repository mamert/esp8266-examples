
dofile("consts.lua")
wifi.setmode(wifi.STATION)
wifi.sta.config(wifiSSID, wifiPass)
print(wifi.sta.getip())
glob_last_temp = "<<undefined>>"

gpio.mode(4,gpio.OUTPUT) -- 4 is GPIO2

tmr.alarm(0, 40000, 1, function() dofile("heartbeat.lua") end ) -- poll weather every minute

-- and run server
srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
		conn:on("receive",function(conn,payload)
			--print(payload) 
		--	conn:send("<h1>Last checked temperature is "..glob_last_temp.."&deg;C</h1>"..
		--	"This node gets its data from api.openweathermap.org, then sends the temperature update to api.thingspeak.com and the vera (assuming it's at <a href=\"http://192.168.0.80/\">192.168.0.80</a>)")
	--		conn:close()
			
			
			
			
			local buf = "";
			local _, _, method, path, vars = string.find(payload, "([A-Z]+) (.+)?(.+) HTTP");
			if(method == nil)then 
				_, _, method, path = string.find(payload, "([A-Z]+) (.+) HTTP"); 
			end
			local _GET = {}
			if (vars ~= nil)then 
				for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do 
					_GET[k] = v 
				end 
			end
			buf = buf.."<h1> Hello, NodeMcu.</h1><form src=\"/\">Turn GPIO2 <select name=\"pin\" onchange=\"form.submit()\">";
			local _on,_off = "",""
			if(_GET.pin == "ON")then
				  _on = " selected=true";
				  gpio.write(4, gpio.HIGH);
			elseif(_GET.pin == "OFF")then
				  _off = " selected=\"true\"";
				  gpio.write(4, gpio.LOW);
			end
			buf = buf.."<option".._on..">ON</opton><option".._off..">OFF</option></select></form>";
			conn:send(buf);
			conn:close();
			collectgarbage();
		end) 
	end)