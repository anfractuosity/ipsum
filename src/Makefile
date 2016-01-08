ipsummake:
	-mkdir lua
	-./generate.sh
	cd LuaJIT-2.0.3 && $(MAKE)
	cd lualanes/src && $(MAKE) 
	cd luasocket && $(MAKE)
	#gcc -fPIC -static -L imlib2-1.4.6/src/lib/.libs/ -I imlib2-1.4.6 -I imlib2-1.4.6/src -I imlib2-1.4.6/src/lib -lImlib2 -lX11 -lpng12 -lpng -lz  -pthread  -ldl imlib2_grab.c -o blah -lImlib2 -lX11 -ldl -lm -lfreetype -lxcb -lz -lpng -lxcb -lXau  -lXext -lXdmcp
	gcc -g2 -L luasocket/src -L lualanes/src -L LuaJIT-2.0.3/src -I luasocket/src -I lualanes/src -I LuaJIT-2.0.3/src -I/usr/include -fPIC -static -ldl ipsum.c -o ipsum -pthread -lluajit -llualanes -lluasocket -lX11 -ldl -lm -lfreetype -lxcb -lz -lpng -lxcb -lXau  -lXext -lXdmcp lua/*.o
