local lanes = require "lanes".configure{ with_timers = false,protect_allocator = true}

local key = require ("keylogging")
local mouse = require("mouselogging")


function callback(evtid,value)
	print("evtid ",evtid)
	
end

threadkey = lanes.gen("*",{globals={["key"]=key}},key.grabber)
threadmouse = lanes.gen("*",{globals={["mouse"]=mouse}},mouse.grabber)

r1 = threadkey(callback)
r2 = threadmouse(callback)

x,y,z = r1:join()
x,y,z = r2:join()

print(x,y,z)
--r1:join()
