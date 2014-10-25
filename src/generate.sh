#!/bin/bash

# Auto generates resource files for .lua files
# and generates header file and C code to include them :)


declare -A memstart
declare -A memsize

cp *.lua lua
find luasocket/src -name "*.lua" | xargs -I {} cp {} lua/
find lualanes/src -name "*.lua" | xargs -I {} cp {} lua/   

cd lua

rm *.o
ls *.lua | xargs -I {} ld -r -b binary -o "{}".o "{}"  

rm ext.h
rm loadlua.c

for f in *.lua.o 
do
	name=$(echo $f|sed "s/\.lua\.o$//g") 
	textaddr=$(objdump -t "$f"  | egrep "_start$" | awk '{ print $5 }')
	echo "extern char $textaddr;" >> ext.h
	memstart[$name]=$textaddr
        textsize=$(objdump -t "$f"  | egrep "_size$" | awk '{ print $5 }')
	echo "extern char $textsize;" >> ext.h

        #textend=$(objdump -t "$f"  | egrep "_end$" | awk '{ print $5 }')
        #echo "extern char $textend;" >> ext.h

	memsize[$name]=$textsize    
done

for f in *.lua.o 
do

	name=$(echo $f|sed "s/\.lua\.o$//g")
	textaddr=${memstart[$name]}
	textsize=${memsize[$name]}

	echo -e "lua_getglobal(L, \"package\");
lua_getfield(L, -1, \"preload\");
luaL_loadbuffer(L,&$textaddr,(uintptr_t)&$textsize,\"$name\");
lua_setfield(L, -2, \"$name\");
lua_pop(L, 2);" >> loadlua.c
	
done
