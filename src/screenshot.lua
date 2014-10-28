_m = {}

function grabber(callback,path)
	i = 0
	while true do
		
		grabscreenshot(path.."screenshot"..tonumber(i)..".png") 
		os.execute("sleep " .. tonumber(60))
		
		i = i + 1
	end


end
_m.grabber = grabber
return _m
