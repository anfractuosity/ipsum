local lanes = require "lanes".configure{ with_timers = false,protect_allocator = true}
local key = require ("keylogging")
local mouse = require("mouselogging")
local xorg = require("xorg")

function callback(evtid,value)
	local utils = require("utils")
	if evtid == 1 or evtid == 2 then
		
		win = utils.gettopwindow()

		if win ~= nil then
			print(win["windowname"])
		end
	end
	
end

threadkey = lanes.gen(key.grabber)
threadmouse = lanes.gen("*",{globals={["mouse"]=mouse}},mouse.grabber)
threadxorg = lanes.gen("*",{globals={["xorg"]=xorg}},xorg.grabber)

r1 = threadkey(callback)
r2 = threadmouse(callback)
r3 = threadxorg(callback)

x,y,z = r3:join()

print(x,y,z)
x,y,z = r1:join()
x,y,z = r2:join()

print(x,y,z)
--r1:join()
