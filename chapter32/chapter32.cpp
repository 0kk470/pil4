#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>
extern "C"
{
#include "../lua_src/lua.h"
#include "../lua_src/lauxlib.h"
#include "../lua_src/lualib.h"
}

void error(lua_State *L, const char *fmt,...)
{
    va_list argp;
    va_start(argp, fmt);
    vfprintf(stderr, fmt, argp);
    va_end(argp);
    lua_close(L);
    printf("\nEnter any key to exit");
    getchar();
    exit(EXIT_FAILURE);
}

static int dir_iter(lua_State *L); /* 前向声明 */

static int l_dir(lua_State *L)
{
    const char *path = luaL_checkstring(L, 1);

    DIR **d = (DIR **)lua_newuserdata(L, sizeof(DIR *));

    *d = NULL;

    luaL_getmetatable(L, "LuaBook.dir");
    lua_setmetatable(L, -2);

    *d = opendir(path);
    if(*d == NULL) /* Open fail*/
        error(L,"cannot open %s: %s", path, strerror(errno));
    
    lua_pushcclosure(L, dir_iter, 1);
    return 1;
}

static int dir_iter(lua_State *L)
{
    DIR *d = *(DIR **)lua_touserdata(L, lua_upvalueindex(1));
    if(d == NULL)
        return 0;
    dirent *entry = readdir(d);
    if(entry != NULL)
    {
        lua_pushstring(L, entry->d_name);
        return 1;
    }else
    {
        if(d) 
        {
            d = NULL;
            lua_remove(L, lua_upvalueindex(1));
        }
        return 0;
    }
}

static int dir_gc(lua_State *L)
{
    printf("dir gc\n");
    DIR *d = *(DIR **)lua_touserdata(L, 1);
    if(d) closedir(d);
    return 0;
}

static const luaL_Reg dirlib [] = {
    {"open",l_dir},
    {NULL,NULL}
};

int luaopen_dir(lua_State *L)
{
    luaL_newmetatable(L, "LuaBook.dir");

    lua_pushcfunction(L,dir_gc);
    lua_setfield(L, -2, "__gc");

    luaL_newlib(L, dirlib);
    return 1;
}

void luaL_opendirlib(lua_State *L)
{
    luaL_requiref(L,"dir",luaopen_dir,1);
    lua_pop(L, 1); 
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    luaL_opendirlib(L);
    if(luaL_dofile(L, "chapter32.lua") != LUA_OK)
    {
        printf("lua error: %s",lua_tostring(L,-1));
    }
    system("Pause");
}