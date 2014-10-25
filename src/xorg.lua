
function grabber(callback)
utils = require("utils")
ffi = utils.ffi




--[[

#define NoEventMask			0L
#define KeyPressMask			(1L<<0)  
#define KeyReleaseMask			(1L<<1)  
#define ButtonPressMask			(1L<<2)  
#define ButtonReleaseMask		(1L<<3)  
#define EnterWindowMask			(1L<<4)  
#define LeaveWindowMask			(1L<<5)  
#define PointerMotionMask		(1L<<6)  
#define PointerMotionHintMask		(1L<<7)  
#define Button1MotionMask		(1L<<8)  
#define Button2MotionMask		(1L<<9)  
#define Button3MotionMask		(1L<<10) 
#define Button4MotionMask		(1L<<11) 
#define Button5MotionMask		(1L<<12) 
#define ButtonMotionMask		(1L<<13) 
#define KeymapStateMask			(1L<<14)
#define ExposureMask			(1L<<15) 
#define VisibilityChangeMask		(1L<<16) 
#define StructureNotifyMask		(1L<<17) 
#define ResizeRedirectMask		(1L<<18) 
#define SubstructureNotifyMask		(1L<<19) 
#define SubstructureRedirectMask	(1L<<20) 
#define FocusChangeMask			(1L<<21) 
#define PropertyChangeMask		(1L<<22) 
#define ColormapChangeMask		(1L<<23) 
#define OwnerGrabButtonMask		(1L<<24) 

]]--


--- #define ScreenOfDisplay(dpy, scr)(&((_XPrivDisplay)dpy)->screens[scr])
-- #define RootWindow(dpy, scr) 	(ScreenOfDisplay(dpy,scr)->root)


local lib_exists, lib = pcall(require, 'bit')

if lib_exists then
	bit = lib
else
	bit = bit32
end

-- property change
mask1 = bit.lshift(1,22)

-- button press - this is banned
mask2 =bit.lshift(1,2)

---button release 
mask3 = bit.lshift(1,3)

-- pointer motion
mask4 = bit.lshift(1,6)

-- visibility change
mask5 = bit.lshift(1,16)

--- enter window notify
mask6 = bit.lshift(1,4)


mask = 0
for i = 21,24 do
	mask = bit.bor(mask,bit.lshift(1,i))
end

local x11 = ffi.load("/usr/lib/x86_64-linux-gnu/libX11.so.6")
if x11 == nil then
	print("failed to find library")
end

s = ":0.0"

dst = ffi.new("char[?]",#s,s)
evt = ffi.new("XEvent")

display = x11.XOpenDisplay(nil)
if display == nil then
	print("failed")
	return
end
--modifiers = x11.XSetLocaleModifiers ("@im=none");                                                                                                                                                               
if x11.XOpenIM(display,nil,nil,nil)==nil then
	print("failed")
	return
end

dscreen = x11.XDefaultScreen(display)
if dscreen == nil then
	print("failed")
	return
end


rwindow = display.screens[dscreen].root

if rwindow == nil then
	print("failed")
	return
end

--window = x11.RootWindow(display,screen)

x11.XSelectInput(display,rwindow,mask)


while true do
	x11.XNextEvent(display,evt)
	--print("WINDOWID ",evt.xproperty.window)


	nitems = ffi.new("unsigned long")
	nbytes = ffi.new("unsigned long")
	data = ffi.new("unsigned char*")
	
	atom = "_NET_ACTIVE_WINDOW"
	at = ffi.new("char[?]",#atom,atom)
	act = ffi.new("unsigned long") 
	fmt = ffi.new("int")

        netactivewindow_atm = x11.XInternAtom(display,at,false)

	nitemsptr = ffi.new("unsigned long[1]",nitems)
	dataptr = ffi.new("unsigned char*[1]",data)
	actptr = ffi.new("unsigned long[1]",act)
	fmtptr = ffi.new("int[1]",fmt)
	nbytesptr = ffi.new("unsigned long[1]",nbytes)

	if netactivewindow_atm == nil then
		print("BadATM")
	end

	eflag = 0

	x11.XSetErrorHandler( function(display,xerror) 			
			
				--print("error",xerror.error_code)
				eflag = 1
			end );
	
	stat = x11.XGetWindowProperty(display,rwindow,netactivewindow_atm,0,2147483647,false,0,actptr,fmtptr,nitemsptr,nbytesptr,dataptr)

	if(stat ~= 0) then
		print("error")
		os.exit(1)
	end


	if actptr[0] > 0 then 
	        window = ffi.cast("unsigned long*",dataptr[0])[0]                                               
		if window == 0 then
		else 
		--	print("about to get stuff from ",window)
	 stat = x11.XGetWindowProperty(display,window,39,0,2147483647,false,0,actptr,fmtptr,nitemsptr,nbytesptr,dataptr)
		
		if stat == 0 then 
			callback(3,{["windowid"]=window,["windowname"]=ffi.string(dataptr[0])})
		end
		end
	end
	x11.XSetErrorHandler(nil)	

end

end



_m = {}
_m.grabber = grabber

return _m
