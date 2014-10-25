#
# Lanes/src/Makefile
#
#   make                                    Manual build
#   make LUAROCKS=1 CFLAGS=... LIBFLAG=...  LuaRocks automated build
#

MODULE=lanes

SRC=lanes.c compat.c threading.c tools.c deep.c keeper.c

OBJ=$(SRC:.c=.o)

# LuaRocks gives 'LIBFLAG' from the outside
#
LIBFLAG=-shared

OPT_FLAGS=-O2
    # -O0 -g

_A=a
ifeq "$(findstring MINGW32,$(shell uname -s))" "MINGW32"
  _A=dll
endif

LUA_FLAGS:=-I. -I/usr/include -I../../LuaJIT-2.0.3/src
LUA_LIBS:=-L/sw/lib -llua
CFLAGS=-Wall $(OPT_FLAGS) $(LUA_FLAGS)
LIBS=$(LUA_LIBS)

#---
# PThread platform specifics
#
ifeq "$(shell uname -s)" "Linux"
  # -D_GNU_AURCE needed for 'pthread_mutexattr_settype'
  CFLAGS += -D_GNU_AURCE -fPIC

  # Use of -DUSE_PTHREAD_TIMEDJOIN is possible, but not recommended (slower & keeps threads
  # unreleased somewhat longer)
  #CFLAGS += -DUSE_PTHREAD_TIMEDJOIN

  LIBS += -lpthread
endif

ifeq "$(shell uname -s)" "BSD"
  LIBS += -lpthread
endif

MODULE_DIR=$(MODULE)

#---
all: $(MODULE)/core.$(_A)

%.o: %.c *.h Makefile

# Note: Don't put $(LUA_LIBS) ahead of $^; MSYS will not like that (I think)
#
$(MODULE_DIR)/core.$(_A): $(OBJ)
	mkdir -p $(MODULE_DIR)
	ar rcs liblualanes.a $^
	#$(CC) $(LIBFLAG) $^ $(LIBS) $(LUA_LIBS) -o $@
	
clean:
	-rm -rf $(MODULE)/core.$(_A) *.o *.map

#---
# NSLU2 "slug" Linux ARM
#
nslu2:
	$(MAKE) all CFLAGS="$(CFLAGS) -I/opt/include -L/opt/lib -D_GNU_AURCE -lpthread"

#---
# Cross compiling to Win32 (MinGW on OS X Intel)
#
# Point WIN32_LUA51 to an extraction of LuaBinaries dll8 and dev packages.
#
# Note: Only works on platforms with same endianess (i.e. not from PowerPC OS X,
#       since 'luac' uses the host endianess)
#
# EXPERIMENTAL; NOT TESTED OF LATE.
#
MINGW_GCC=mingw32-gcc
    # i686-pc-mingw32-gcc

win32: $(WIN32_LUA51)/include/lua.h
	$(MAKE) build CC=$(MINGW_GCC) \
            LUA_FLAGS=-I$(WIN32_LUA51)/include \
            LUA_LIBS="-L$(WIN32_LUA51) -llua51" \
            _A=dll \
            SO_FLAGS=-shared

$(WIN32_LUA51)/include/lua.h:
	@echo "Usage: make win32 WIN32_LUA51=<path of extracted LuaBinaries dll8 and dev packages>"
	@echo "                  [MINGW_GCC=...mingw32-gcc]"
	@false

.PROXY:	all clean nslu2 win32
