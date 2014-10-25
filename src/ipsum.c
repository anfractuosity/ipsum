#include <stdio.h>
#include "luajit.h"
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "lanes.h"
#include "tools.h"
#include "luasocket.h"
#include "lua/ext.h"
#include <stdint.h>

lua_State* L;

int luaopen_mymodule(lua_State *L){
	lua_getglobal(L, "package");
	lua_getfield(L, -1, "preload");
	lua_pushcfunction(L, luaopen_socket_core);                                                                                          	   lua_setfield(L,-2,"socket.core");
	lua_pop(L,2);
	return 0;
}


int main ( int argc, char *argv[] )
{
	L = luaL_newstate();

    	luaL_openlibs(L); /* Load Lua libraries */
	lua_register(L, "luaopen_mymodule", luaopen_mymodule); 

	lua_getglobal(L, "package");
	lua_getfield(L, -1, "preload");
	lua_pushcfunction(L, luaopen_socket_core);
	lua_setfield(L,-2,"socket.core");
	lua_pop(L,2);

	luaL_requiref( L, "lanes.core", luaopen_lanes_core, 1);

	#include "lua/loadlua.c"

	intptr_t si =  &_binary_ipsum_lua_size;
	char *tmp = malloc(si+1);
	memset(tmp,0,si+1);
	memcpy(tmp,&_binary_ipsum_lua_start,si);

	int ret = luaL_dostring(L,tmp);

	if(ret!=0){
		printf("%s\n", lua_tostring(L, -1));
	}

	lua_close(L);
	return 0;
}

