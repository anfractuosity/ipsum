function grabber(callback)
	utils = require("utils")

	key = {}
	local file = io.open(ev, "rb")

	if not file then
		print("Not root")
		return 
	end
	
	
	-- kcode
	--[[
		#define REL_X			0x00
		#define REL_Y			0x01
	]]--


	--ktype
	--[[
		#define EV_KEY			0x01
		#define EV_REL			0x02
		#define EV_ABS			0x03
	]]--

	--[[
		#define BTN_MOUSE		0x110
#define BTN_LEFT		0x110
#define BTN_RIGHT		0x111
#define BTN_MIDDLE		0x112
#define BTN_SIDE		0x113
#define BTN_EXTRA		0x114
#define BTN_FORWARD		0x115
#define BTN_BACK		0x116
#define BTN_TASK		0x117

	]]--




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

			-- left 
		if ktype == 1 and (kcode == 272 or kcode == 273) and value == 1 then	
			--print(ktype,kcode,value)
			callback(2)		
		end

		if ktype == 3 and (kcode == 0 or kcode == 1) then
		--	print("axis ",kcode," pos ",value)
		end
	end
end

_m = {}
_m.grabber = grabber

return _m
