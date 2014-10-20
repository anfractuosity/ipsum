function conv(str)
	sum = 0
	for i=1,#str do
		if i == 1 then
			n = 0
		elseif i == 2 then
			n = 8
		else
			n = n * 2
		end
		sum = sum + (string.byte(str,i)*math.pow(2,n))
	end
	return sum
end

function grabber()

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
		--[[time  =  file:read(16)
		ktype = file:read(2)
		kcode = file:read(2)
		value = file:read(4)]]--

		time = string.sub(all,1,16)
		ktype = string.sub(all,17,18)
		kcode = string.sub(all,19,20)
		value = string.sub(all,21,24)


		--print(#time,#ktype,#kcode,#value)
		ktype = conv(ktype)
		kcode = conv(kcode)
		value = conv(value)
		
		--print(ktype,kcode,value)
		if (value == 1 or value == 2) then
			print("KEY ",value,"   ",key[kcode])
		end
	end
end


grabber()
