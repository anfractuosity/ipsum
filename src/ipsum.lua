local lanes = require "lanes".configure{ with_timers = false,protect_allocator = true}
local key = require ("keylogging")
local mouse = require("mouselogging")
local xorg = require("xorg")

lasthash = {["tmp"]="hi"}

local lind = lanes.linda()
local lock = lanes.genlock(lind,"M",1)


function callback(evtid,value)
	
	function clear(l)
		d = l:dump()
		if d == nil then
			return
		end
		for k,v in pairs(d) do
			l:set(k,nil)
		end
	end


	c = 0
	for k,v in pairs(lasthash) do
		c = c + 1
	
	end

	print("HASH LEN ",c)
	local utils = require("utils")
	if evtid == 1 or evtid == 2 then
		win = utils.gettopwindow()
		if win ~= nil then
			lock(1)
			if not lind:get(win["windowid"]) then
				print(">>>>>>>>>>>>> ",win["windowname"])
			else
				print("HEEEEEEEEEEEEEEEREEEEEEEEEE")
			end
			
			--lasthash = {}
			clear(lind)
			lind.set(win["windowid"],1)
			lock(-1)

		else
			print("Failed to grab window")
		end
	end
	if evtid == 3 then
		lock(1)
	               	 
			if lind:get(value["windowid"]) ~= nil then                                                           
                                print(">>>>>>>>>>>>> ",value["windowname"])                                               
                        else                                                                                            
                                print("HEEEEEEEEEEEEEEEREEEEEEEEEE")                                                    
                        end                                                                                             
                                                                                                                        
                        --lasthash = {}                                                                                 
                        clear(lind)                                                                                     
                        lind.set(value["windowid"],1)  	
		--lasthash = {}
		clear(lind)
		lock(-1)
	end
	
end

glob={["lasthash"]=lasthash, 
      ["lind"]=lind,
     ["lock"]=lock
     }




JSON = require("JSON") 


local settings = JSON:decode([[{"hi":"bob"}]]) -- decode example


print(settings["hi"])







threadkey = lanes.gen("*",{globals=glob},key.grabber)
threadmouse = lanes.gen("*",{globals=glob},mouse.grabber)
threadxorg = lanes.gen("*",{globals=glob},xorg.grabber)

r1 = threadkey(callback)
r2 = threadmouse(callback)
r3 = threadxorg(callback)

x,y,z = r3:join()

print(x,y,z)
x,y,z = r1:join()
x,y,z = r2:join()

print(x,y,z)
--r1:join()
