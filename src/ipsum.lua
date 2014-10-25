local lanes = require "lanes".configure{ with_timers = false,protect_allocator = true,on_state_create = luaopen_mymodule}
local key = require ("keylogging")
local mouse = require("mouselogging")
local xorg = require("xorg")
io.stdout:setvbuf 'no' 
lasthash = {["tmp"]="hi"}

local lind = lanes.linda()
local lock = lanes.genlock(lind,"M",1)


function callback(evtid,value)
	if evtid==3 then
		print("call back ",evtid," ",value["windowname"])
	else
		print("call back ",evtid," ",value)
	end
end

glob={["lasthash"]=lasthash, 
      ["lind"]=lind,
     ["lock"]=lock
     }




JSON = require("JSON") 


--local settings = JSON:decode([[{"hi":"bob"}]]) -- decode example


--print(settings["hi"])







threadkey = lanes.gen("*",{globals=glob},key.grabber)
threadmouse = lanes.gen("*",{globals=glob},mouse.grabber)
threadxorg = lanes.gen("*",{globals=glob},xorg.grabber)

r1 = threadkey(callback)
r2 = threadmouse(callback)
r3 = threadxorg(callback)


--x,y,z = r3:join()

x,y,z = r1:join()
x,y,z = r2:join()
x,y,z = r3:join()
--r1:join()

print(x,y,z)
