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
	local file = io.open("/dev/input/event3", "rb")

	if not file then
		print("Not root")
		return 
	end
	
	go = true
	while go do
		time = file:read(16)
		ktype = file:read(2)
		kcode = file:read(2)
		value = file:read(4)

		ktype = conv(ktype)
		kcode = conv(kcode)
		value = conv(value)
		
		if ktype == 4 and kcode == 4 then
			print(value)
		end
	end
end


grabber()
