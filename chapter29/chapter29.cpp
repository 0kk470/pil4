#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>
extern "C"
{
#include "../lua_src/lua.h"
#include "../lua_src/lauxlib.h"
#include "../lua_src/lualib.h"
}

static int summation(lua_State* L)
{
    lua_Number sum = 0;
    int n = lua_gettop(L);
    for(int i = 1;i <=n; i++)
       sum += luaL_checknumber(L, i);
    lua_pushnumber(L,sum);
    return 1;
}

static int pack(lua_State* L)
{
    int n = lua_gettop(L);
    lua_newtable(L);
    lua_insert(L,1);
    for(int i = 1; i <= n; i++)
    {
        lua_pushinteger(L,n - i + 1);
        lua_insert(L,-2);
        lua_settable(L,1);
    }
    return 1;
}

static const struct luaL_Reg mylib [] =
{
    {"summation",summation},
    {"pack",pack},
    {NULL,NULL},
};

LUAMOD_API int luaopen_mylib(lua_State* L)
{
    luaL_newlib(L,mylib);
    return 1;
}

void luaL_openmylib(lua_State* L)
{
    luaL_requiref(L,"mylib",luaopen_mylib,1);
    lua_pop(L, 1); 
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    luaL_openmylib(L);
    if(luaL_dofile(L, "chapter29.lua") != LUA_OK)
    {
        printf("lua error: %s",lua_tostring(L,-1));
    }
    system("Pause");
}