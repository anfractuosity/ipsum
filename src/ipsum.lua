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


	
grabscreenshot()


JSON = require("JSON") 

file = io.open("settings.json", "r")
if file == nil then
	print("Need settings.json")
	return
end

local settings = JSON:decode(file:read("*all")) -- decode example


if arg[1] ~= nil and arg[1] == "dump" then

	local mp = require ("MessagePack")
	local ltn12 = require 'ltn12'


	src = ltn12.source.file(io.open(settings["keylog"], 'rb'))

	for _, v in mp.unpacker(src) do
		c = nil
    		if v[2] ~= nil then
			c = string.byte(v[2])
    		end
    		print("Time ",v[1]," key char ",c," key mod ",v[3])
	end

        src = ltn12.source.file(io.open(settings["xlog"], 'rb'))                                                             
                                                                                                                               
        for _, v in mp.unpacker(src) do                                                                                        
                print("Time ",v[1]," Window id ",v[2]," Window title ",v[3])                                                            
        end    

	
	return

end 







threadkey = lanes.gen("*",{globals=glob},key.grabber)
threadmouse = lanes.gen("*",{globals=glob},mouse.grabber)
threadxorg = lanes.gen("*",{globals=glob},xorg.grabber)

r1 = threadkey(callback,settings["keyboard"],settings["keyboardmap"],settings["keylog"])
r2 = threadmouse(callback,settings["mouse"])
r3 = threadxorg(callback,settings["xlog"])

x,y,z = r3:join()
x,y,z = r2:join()
x,y,z = r1:join()
