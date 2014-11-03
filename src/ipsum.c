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

#include "config.h"
#include <X11/Xlib.h>
#include <X11/extensions/XShm.h>
#include <X11/Xutil.h>
#include <X11/extensions/shape.h>
#include <X11/Xatom.h>
#include <X11/Xos.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>
#include "Imlib2.h"








int grabscreenshot();

lua_State* L;

int luaopen_mymodule(lua_State *L){
	
	lua_getglobal(L, "package");
	lua_getfield(L, -1, "preload");
	lua_pushcfunction(L, luaopen_socket_core);                                                                                          	   
	lua_setfield(L,-2,"socket.core");
	lua_pop(L,2);
	
         lua_register(L,"grabscreenshot",grabscreenshot);                                                                                                                                                        


	return 0;
}

extern int core(lua_State *L){

}

    void setfield (const int index, char *value) {
      lua_pushnumber(L, index);
      lua_pushstring(L, value);
      lua_settable(L, -3);
    }


Display            *disp;
Visual             *vis;
Colormap            cm;
int                 depth;
int                 image_width = 0, image_height = 0;






int grabscreenshot(lua_State *L)
{
   char               *s;
   Imlib_Image        *im = NULL;
   char               *file = NULL;
   int                 verbose;
   int                 get_alpha;
   const char         *display_name = getenv("DISPLAY");
   Drawable            draw;
   int                 x, y;
   unsigned int        w, h, bw, depth;
   unsigned int        wo, ho;
   Window              rr;

   verbose = 1;
   get_alpha = 1;
   draw = None;
   wo = ho = 0;



   file = lua_tostring(L, 1);

   if (!display_name)
      display_name = ":0";
   disp = XOpenDisplay(display_name);
   if (!disp)
     {
        fprintf(stderr, "Can't open display %s\n", display_name);
        return 1;
     }

   vis = DefaultVisual(disp, DefaultScreen(disp));
   depth = DefaultDepth(disp, DefaultScreen(disp));
   cm = DefaultColormap(disp, DefaultScreen(disp));
   imlib_context_set_display(disp);
   imlib_context_set_visual(vis);
   imlib_context_set_colormap(cm);

   if (draw == None)
      draw = DefaultRootWindow(disp);
   imlib_context_set_drawable(draw);

   XGetGeometry(disp, draw, &rr, &x, &y, &w, &h, &bw, &depth);
   if (wo == 0)
      wo = w;
   if (ho == 0)
      ho = h;
   if (verbose)
     {
        printf("Drawable: %#lx: x,y: %d,%d  wxh=%ux%u  bw=%u  depth=%u\n",
               draw, x, y, w, h, bw, depth);
        if ((wo != w) || (ho != h))
           printf("Output  : wxh=%ux%u\n", wo, ho);
     }

   if ((wo != w) || (ho != h))
      im = imlib_create_scaled_image_from_drawable(None, 0, 0, w, h, wo, ho, 1,
                                                   (get_alpha) ? 1 : 0);
   else
      im = imlib_create_image_from_drawable((get_alpha) ? 1 : 0, 0, 0, w, h, 1);
   if (!im)
     {
        fprintf(stderr, "Cannot grab image!\n");
        exit(0);
     }

   imlib_context_set_image(im);

//printf("%d\n",im->loader->load);

Imlib_Load_Error err;
imlib_save_image_with_error_return(file,&err);
	
	XCloseDisplay(disp);

 //  imlib_save_image(file);
	printf("here\n");
   return 0;
}






















int main ( int argc, char *argv[] )
{
	L = luaL_newstate();

    	luaL_openlibs(L); /* Load Lua libraries */

	//luaopen_package(L);
	
	luaL_requiref(L, "lanes.core", luaopen_lanes_core, 1); 
	lua_register(L, "luaopen_mymodule", luaopen_mymodule);

	lua_register(L,"grabscreenshot",grabscreenshot); 


      //  lua_pushcfunction(L, grabscreenshot);                                                                                                 
      //  lua_setfield(L,-2,"grabscreenshot"); 




	lua_getglobal(L, "package");
	lua_getfield(L, -1, "preload");
	lua_pushcfunction(L, luaopen_socket_core);
	lua_setfield(L,-2,"socket.core"); 
	lua_pop(L,2);

	//luaopen_socket_core(L);

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

