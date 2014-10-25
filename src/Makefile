ipsummake:
	-./generate.sh
	cd LuaJIT-2.0.3 && $(MAKE)
	cd lualanes/src && $(MAKE) 
	cd luasocket/src && $(MAKE)
	gcc -g2 -L luasocket/src -L lualanes/src -L LuaJIT-2.0.3/src -I luasocket/src -I lualanes/src -I LuaJIT-2.0.3/src -I/usr/include -fPIC -static  ipsum.c -lluajit -llualanes -lluasocket -lm -ldl -pthread lua/*.o -o ipsum 



