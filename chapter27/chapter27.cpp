//g++.exe -g main.cpp -o main.exe -llua
//put 'liblua.a' in the mingw's library path.  (e.g. C:\TDM-GCC-64\x86_64-w64-mingw32\lib)
#include <stdio.h>
#include <string.h>
extern "C"
{
#include "../lua_src/lua.h"
#include "../lua_src/lauxlib.h"
#include "../lua_src/lualib.h"
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

void Example27_2()
{
    lua_State *L = luaL_newstate();

    lua_pushboolean(L, 1);
    lua_pushnumber(L, 10);
    lua_pushnil(L);
    lua_pushstring(L, "hello");

    stackDump(L);                        // true 10 nil hello

    lua_pushvalue(L, -4);  stackDump(L); // true 10 nil hello true

    lua_replace(L, 3); stackDump(L);  // true 10 true hello

    lua_settop(L, 6); stackDump(L);  // true 10 true hello nil nil

    lua_rotate(L, 3, 1); stackDump(L); // true 10 nil true hello nil

    lua_remove(L, -3); stackDump(L); // true 10 nil hello nil

    lua_settop(L, -5); stackDump(L); // true

    lua_close(L);
}

void Exercise27_1()
{
    printf("simple lua.exe\n");
    char buff[255];
    int error;
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    while (fgets(buff, sizeof(buff), stdin) != NULL)
    {
        error = luaL_loadstring(L, buff) || lua_pcall(L, 0, 0, 0);
        if (error)
        {
            fprintf(stderr, "%s\n", lua_tostring(L, -1));
            lua_pop(L, 1);
        }
    }
}

void Exercise27_2()
{
    lua_State *L = luaL_newstate();
    lua_pushnumber(L, 3.5);     // 3.5
    lua_pushstring(L, "hello"); // 3.5 hello
    lua_pushnil(L);             // 3.5 hello nil
    lua_rotate(L, 1, -1);       // hello nil 3.5
    lua_pushvalue(L, -2);       // hello nil 3.5 nil
    lua_remove(L, 1);           // nil 3.5 nil
    lua_insert(L, -2);          // nil nil 3.5

    // exercise27_3
    stackDump(L);
}

int main(void)
{
    //Example27_2();
    //Exercise27_1();
    Exercise27_2();
    getchar();
}