function grabber(callback)
	utils = require("utils")

	print("here")
	key = {}
	local map = io.open("maps/en_GB.map","r")
	l = map:read("*l")
	while l ~= nil do
		table.insert(key,l)
		l = map:read("*l")
	end
	
	local file = io.open("/dev/input/event3", "rb")

	if not file then
		print("Not root")
		return 
	end
	
	go = true
	while go do
		all = file:read(24)

		time = string.sub(all,1,16)
		ktype = string.sub(all,17,18)
		kcode = string.sub(all,19,20)
		value = string.sub(all,21,24)

		ktype = utils.conv(ktype)
		kcode = utils.conv(kcode)
		value = utils.conv(value)
		
		if (value == 1 or value == 2) then
			callback(1,key[kcode])
		end
	end
end

_m = {}
_m.grabber = grabber
return _m
