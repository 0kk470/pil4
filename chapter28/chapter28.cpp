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

void call_va(lua_State *L,const char *func,const char *sig,...)
{
    va_list vl;
    int narg, nres;
 
    va_start(vl, sig);
    //函数入栈
    lua_getglobal(L, func);
    //参数入栈
    for(narg = 0; *sig; narg++)
    {
        luaL_checkstack(L, 1, "too many arguments");
        switch (*sig++)
        {
        case 'd':
            lua_pushnumber(L, va_arg(vl, double));
            break;
        case 'i':
            lua_pushinteger(L, va_arg(vl, int));
            break;
        case 's':
            lua_pushstring(L, va_arg(vl, char*));
            break;
        case '>':
            goto endargs;
        case 'b':
            lua_pushboolean(L, va_arg(vl, int));
            break;
        default:
            error(L, "push value error, invalid option (%c)", *(sig - 1));
        }
    }
    endargs:
    nres = strlen(sig);
    if(lua_pcall(L, narg, nres, 0) != LUA_OK )
    {
        error(L, "error calling '%s': %s", func, lua_tostring(L, -1));
    }
    //检索结果
    nres = -nres; /*第一个结果的栈索引*/
    while(*sig)
    {
        switch (*sig++)
        {
        case 'd':
            {
                int isnum;
                double n = lua_tonumberx(L, nres, &isnum);
                if(!isnum)
                  error(L, "wrong result type");
                *va_arg(vl, double*) = n;
                break;
            }
        case 'i':
            {
                int isnum;
                int n = lua_tointegerx(L, nres, &isnum);
                if(!isnum)
                  error(L, "wrong result type");
                *va_arg(vl, int*) = n;
                break;
            }
        case 's':
            {
                const char *s = lua_tostring(L, nres);
                if(s == NULL)
                  error(L, "wrong result type");
                *va_arg(vl, const char **) = s;
                break;
            }
        case 'b':
            {
                if(lua_isboolean(L, nres))
                  error(L, "wrong result type");
                bool b = lua_toboolean(L,nres);
                *va_arg(vl, bool*) = b;
                break;
            }
        default:
            error(L, "invalid option (%c)", *(sig - 1));
        }
        nres++;
    }
    va_end(vl);
}

void printchar(char c,int num)
{
    for(int i = 0; i < num; i++)
    {
        putchar(c);
    }
    printf("\n");
}

void Exercise28_1()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    if(luaL_dofile(L, "chapter28.lua") == 0)
    {
        for(int i = 1; i <= 20; i++)
        {
            int result = 0;
            call_va(L, "f", "i>i", i, &result);
            lua_pop(L, 1);
            printchar('*', result);
        }
    }
    else
    {
        error(L,"Failed to load chapter28.lua,Error:%s",lua_tostring(L,-1));
    }
    lua_close(L);
}

void Exercise28_2()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    if(luaL_dofile(L, "chapter28.lua") == 0)
    {
        call_va(L, "checkboolean", "b", true);
    }
    else
    {
        error(L,"Failed to load chapter28.lua,Error:%s",lua_tostring(L,-1));
    }
    lua_close(L);
}

int main()
{
    //Exercise28_1();
    //Exercise28_2();
    system("pause");
}