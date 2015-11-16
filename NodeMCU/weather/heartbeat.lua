
owmAppId = "..."
tsKey = "..."

function getWeather()
	local conn=net.createConnection(net.TCP, 0) 

	conn:on("connection", function(conn, payload)
				conn:send("GET /data/2.5/weather?lat=54.3652832&lon=18.6571822&appid="..
						  owmAppId..
						  "&units=metric HTTP/1.1\r\n".. 
						  "Host: api.openweathermap.org\r\n"..
						  "Accept: */*\r\n"..
						  "User-Agent: Mozilla/4.0 (compatible;)"..
						  "\r\n\r\n") 
				end)
				
	conn:on("receive", function(conn, payload)
			glob_last_temp = string.match(payload,"{\"temp\":(%-?%d+%.%d+)")
			print("OpenWeatherMap:\n"..glob_last_temp)
			conn:close()
			sendThingSpeakUpdate(glob_last_temp)
			sendVeraUpdate(glob_last_temp)
		end)
	conn:connect(80,'api.openweathermap.org')
end


function sendThingSpeakUpdate(value)
	local conn=net.createConnection(net.TCP, 0) 
	conn:on("receive", function(conn, payload)
			print("ThingSpeak:\n"..payload)
			conn:close()
		end) 
	
	conn:on("connection", function(conn, payload)
			conn:send("GET /update?key="..
					  tsKey..
					  "&field1="..value.." HTTP/1.1\r\n".. 
					  "Host: api.thingspeak.com\r\n"..
					  "Accept: */*\r\n"..
					  "User-Agent: Mozilla/4.0 (compatible;)"..
					  "\r\n\r\n") 
		end)
	conn:connect(80,'api.thingspeak.com') --184.106.153.149
end

function sendVeraUpdate(value)
	local conn=net.createConnection(net.TCP, 0) 
	conn:on("receive", function(conn, payload)
			print("Vera:\n"..payload)
			conn:close()
		end) 
	
	conn:on("connection", function(conn, payload)
			conn:send("GET /data_request?id=variableset&DeviceNum=43&serviceId=urn:upnp-org:serviceId:TemperatureSensor1&Variable=CurrentTemperature&Value="..
						value..
						" HTTP/1.1\r\n".. 
						"Host: \r\n"..
						"Accept: */*\r\n"..
						"User-Agent: Mozilla/4.0 (compatible;)"..
						"\r\n\r\n") 
		end)
	conn:connect(3480,'192.168.0.80') --184.106.153.149
end

------------------
getWeather()
