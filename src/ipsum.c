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

extern int core(lua_State *L){

}

    void setfield (const int index, char *value) {
      lua_pushnumber(L, index);
      lua_pushstring(L, value);
      lua_settable(L, -3);
    }



int main ( int argc, char *argv[] )
{
	L = luaL_newstate();

    	luaL_openlibs(L); /* Load Lua libraries */

	//luaopen_package(L);
	
	luaL_requiref(L, "lanes.core", luaopen_lanes_core, 1); 
	lua_register(L, "luaopen_mymodule", luaopen_mymodule); 

	lua_getglobal(L, "package");
	lua_getfield(L, -1, "preload");
	lua_pushcfunction(L, luaopen_socket_core);
	lua_setfield(L,-2,"socket.core"); 
	lua_pop(L,2);

	lua_newtable(L);

	int i = 1;

	for(i=1;i<argc+1;i++){
	      	setfield(i,argv[i]);       /* table.b = ct->b */
	}
      	lua_setglobal(L, "arg");    /* `name' = table */





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

