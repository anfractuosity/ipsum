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

_m = {}
_m.conv = conv

return _m
