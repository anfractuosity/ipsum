local lanes = require "lanes".configure{ with_timers = false,protect_allocator = true}
local key = require ("keylogging")
local mouse = require("mouselogging")
local xorg = require("xorg")

function callback(evtid,value)
	local utils = require("utils")
	if evtid == 1 or evtid == 2 then
		print("Trying to grab top")	
		win = utils.gettopwindow()
		print("Hanging?")
		if win ~= nil then
			print(">>>>>>>>>>>>>   ",win["windowname"])
		else
			print("Failed to grab window")
		end
	end
	
end

threadkey = lanes.gen("*",{},key.grabber)
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
