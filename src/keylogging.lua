function grabber(callback,ev,keymap)
	socket = require("socket")
	weight = {
	      ["Shift"]=		        1,
	      ["AltGr"]=			2,
	      ["Control"]=			4,
	      ["Alt"]=			        8,
	      ["ShiftL"]=		       16,
	      ["ShiftR"]=		       32,
	      ["CtrlL"]=		       64,
	      ["CtrlR"]=		      128

                 }

	keytable = {}
	
	



	utils = require("utils")

	key = {}
	local map = io.open(keymap,"r")
	l = map:read("*l")
	while l ~= nil do
		tbl = {}
		
		i = 1
		for col in string.gmatch(l, "([^ ]+)") do 
			tbl[i] = col
			i = i + 1
		end
	
		table.insert(key,tbl)
		

		l = map:read("*l")
	end
	
	local file = io.open(ev, "rb")

	if not file then
		print("Not root")
		return 
	end

	activekeys = {}
	for i=1,256 do
		activekeys[i] = 0
	end
		
	go = true
	while go do
		all = file:read(24)

		if #all ~= 24 then
			print("Odd")
			os.exit()
		end	

		time = string.sub(all,1,16)
		ktype = string.sub(all,17,18)
		kcode = string.sub(all,19,20)
		value = string.sub(all,21,24)


		time = utils.conv(time)
		ktype = string.byte(ktype,1,1)
		kcode = string.byte(kcode,1,1)
		--kcode = utils.conv(kcode)
		value = string.byte(value,1,1)
		--print(ktype,kcode,value)


		
		if ktype ~= 1 then
			  --print("Odd ktype - ",ktype)
			  goto cont
		end

			if value == 0 then
				-- value == 0 ---- key release
				activekeys[kcode] = 0
			
			elseif value == 1 or value == 2 then

				
				if value == 1 then
					activekeys[kcode] = 1
				else
					activekeys[kcode] = 2
				end

					
				repkeycode = -1
				repkeycoder = -1

				sum = 0
				active = 0
				for i=1,255 do
					if activekeys[i] >= 1 then
						w = weight[key[i][1]] 
						if w ~= nil then
							sum = sum + w
						else
							if activekeys[i] == 2 then
								repkeycoder = i
							else
								repkeycode = i
							end
						end
						active = active + 1
					end
				end
		
				--print("WSUM ",sum," ACTIVE ",active)

				if active > 1 then --and weight[key[kcode][1]] ~= nil then
					-- ok so we've got a modifier
					-- pick last non-modifier key
					if repkeycoder > -1 then 
						kcode = repkeycoder
						--sum = 0
					elseif repkeycode > -1 then
						kcode = repkeycode
						--sum = 0
					end
			
				end
			
				
				k = key[kcode][sum+1]
				print("press ",k," @ time = ",socket.gettime()," active= ",active," weight= ",sum)
                                --callback(1,"press "..k)



				-- value == 1 ---- key press
				-- value == 2 ---- key repeat
				--callback(1,key[kcode])
			end

		::cont::
	end
end

_m = {}
_m.grabber = grabber
return _m
