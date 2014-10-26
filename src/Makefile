ipsummake:
	-mkdir lua
	-./generate.sh
	cd LuaJIT-2.0.3 && $(MAKE)
	cd lualanes/src && $(MAKE) 
	cd luasocket && $(MAKE)
	#cd imlib2-1.4.6  && ./configure && $(MAKE)
	gcc -g2 -L luasocket/src -L imlib2-1.4.6/src/lib/.libs/ -L lualanes/src -L LuaJIT-2.0.3/src -I imlib2-1.4.6/src  -I luasocket/src -I lualanes/src -I LuaJIT-2.0.3/src -I/usr/include -fPIC -static  ipsum.c -lluajit -llualanes -lluasocket -lm -ldl -pthread lua/*.o -o ipsum 



