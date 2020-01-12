#include <stdio.h>
#include <string.h>
#include <stdlib.h>
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

static void stackDump(lua_State *L)
{
    int i;
    int top = lua_gettop(L); // stack's depth
    for (i = 1; i <= top; i++)
    {
        int t = lua_type(L, i);
        switch (t)
        {
          case LUA_TSTRING:
          {
              printf("'%s'", lua_tostring(L, i));
              break;
          }
          case LUA_TBOOLEAN:
          {
              printf(lua_toboolean(L, i) ? "true" : "false");
              break;
          }
          case LUA_TNUMBER:
          {
              printf("%g", lua_tonumber(L, i));
              break;
          }
          default:
          {
              printf("%s", lua_typename(L, t));
              break;
          }
        }
        printf(" ");
    }
    printf("\n");
}

static int l_filter(lua_State* L) //Exercise 30.1
{
    luaL_checktype(L, 1, LUA_TTABLE);
    luaL_checktype(L, 2, LUA_TFUNCTION);
    lua_newtable(L);
    lua_insert(L , 1);
    int index = 0;
    int n = luaL_len(L, 2);
    for(int i = 1; i <= n; i++ )
    {
        //复制比较函数
        lua_pushvalue(L, -1);
        //将表值作为参数压入
        lua_geti(L, 2, i);
        //复制的值备用
        lua_pushvalue(L, -1);
        lua_insert(L, -3);
        lua_pcall(L, 1, 1, 0);
        if(lua_isboolean(L, -1) != 0)
        {
            int ret = lua_toboolean(L, -1);
            lua_pop(L, 1);
            if( ret != 0 )
                lua_seti(L, 1, ++index);
            else 
                lua_pop(L, 1);
        }
        else
        {
           error(L, "compare function should return boolean value!");
        }     
    }
    lua_pop(L, 2);
    return 1;
}

static const struct luaL_Reg mylib [] =
{
    {"filter",l_filter},
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
    if(luaL_dofile(L, "chapter30.lua") != LUA_OK)
    {
        printf("lua error: %s",lua_tostring(L,-1));
    }
    system("Pause");
}