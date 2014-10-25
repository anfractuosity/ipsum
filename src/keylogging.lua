function grabber(callback,ev,keymap)

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





	utils = require("utils")

	key = {}
	local map = io.open(keymap,"r")
	l = map:read("*l")
	while l ~= nil do
		table.insert(key,l)
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

		ktype = string.byte(ktype,1,1)
		kcode = string.byte(kcode,1,1)
		--kcode = utils.conv(kcode)
		value = string.byte(value,1,1)
		--print(ktype,kcode,value)

		
		if ktype ~= 1 then
			  goto cont
		end

		if (value == 0 or value == 1 or value == 2) then
			if value == 0 then
				-- value == 0 ---- key release
				activekeys[kcode] = 0
			
			else
				activekeys[kcode] = 1



                                if kcode > 0 then

					line = key[kcode]
					i = 0


				


					cols = {}
        				for col in string.gmatch(line, "([^ ]+)") do
        					i = i + 1	
						cols[i] = col	
					end

					k = cols[1]					


                                       callback(1,"press "..k)
                                end

			

















				-- value == 1 ---- key press
				-- value == 2 ---- key repeat
				--callback(1,key[kcode])
			end
		end

		::cont::
	end
end

_m = {}
_m.grabber = grabber
return _m
