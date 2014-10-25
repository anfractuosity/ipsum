ipsummake:
	-./generate
	gcc -g2 -L luasocket/src -L lanes/src -L LuaJIT-2.0.3/src -I luasocket/src -I lanes/src -I LuaJIT-2.0.3/src -I/usr/include -fPIC -static  ipsum.c -lluajit -llanes -lluasocket -lm -ldl -pthread lua/*.o -o ipsum 



