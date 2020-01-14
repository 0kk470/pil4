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

static int l_split(lua_State *L) //Exercise 30.2
{
    const char *s = luaL_checkstring(L, 1);
    const char *sep = luaL_checkstring(L, 2);
    int len = luaL_len(L, 1);
    const char *e;
    int i = 1;
    lua_newtable(L);
    while( (e = (char*)memchr(s, *sep, len)) != NULL)
    {
        lua_pushlstring(L, s, e - s);
        lua_rawseti(L, -2, i++);
        len -= e - s;
        s = e + 1;
    }
    lua_pushstring(L, s);
    lua_rawseti(L, -2 , i);

    return 1;
}

/* Exercise 30.3 ~ Exercise 30.4 */
static char key = 'k';
int l_settrans_reg(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TTABLE);
    lua_rawsetp(L,LUA_REGISTRYINDEX,(void *)&key);
    return 0;
}

int l_gettrans_reg(lua_State *L)
{
    int t = lua_rawgetp(L,LUA_REGISTRYINDEX,(void *)&key);
    if(t != LUA_TTABLE) 
        error(L, "You have not set a table for function 'transliterate', gettrans failed!");
    return 1;
}

int l_transliterate_reg(lua_State *L) 
{
    const char *s = luaL_checkstring(L, -1);
    size_t l = luaL_len(L, -1);
    const char *end = s + l;
    luaL_Buffer b;
    luaL_buffinitsize(L, &b, l);
    char key[2] = {'\0','\0'};
    l_gettrans_reg(L);
    luaL_checktype(L, -1 , LUA_TTABLE);
    int t  = LUA_TNIL;
    while(s != end)
    {
        strncpy(key, s, 1);
        t = lua_getfield(L, -1, key);
        switch (t)
        {
            case LUA_TSTRING:
                luaL_addstring(&b,lua_tostring(L, -1));
                break;
            case LUA_TBOOLEAN:
                if(lua_toboolean(L, -1) != 0)
                    luaL_addchar(&b, *s);
                break;
            default:
                luaL_addchar(&b, *s);
                break;
        }
        lua_pop(L, 1);
        ++s;
    }
    lua_settop(L, 0);
    luaL_pushresult(&b);
    return 1;
}

/* Exercise 30.5 */
int l_settrans_upvalue(lua_State *L)
{
    luaL_checktype(L, 1, LUA_TTABLE);
    lua_copy(L, -1, lua_upvalueindex(1) );
    return 0;
}

int l_gettrans_upvalue(lua_State *L)
{
    lua_pushvalue(L, lua_upvalueindex(1));
    if(!lua_istable(L, -1))
        error(L, "You have not set a table for function 'transliterate', gettrans failed!");
    return 1;
}

int l_transliterate_upvalue(lua_State *L) 
{
    const char *s = luaL_checkstring(L, -1);
    size_t l = luaL_len(L, -1);
    const char *end = s + l;
    luaL_Buffer b;
    luaL_buffinitsize(L, &b, l);
    char key[2] = {'\0','\0'};
    l_gettrans_upvalue(L);
    stackDump(L);
    luaL_checktype(L, -1 , LUA_TTABLE);
    int t  = LUA_TNIL;
    while(s != end)
    {
        strncpy(key, s, 1);
        t = lua_getfield(L, -1, key);
        switch (t)
        {
            case LUA_TSTRING:
                luaL_addstring(&b,lua_tostring(L, -1));
                break;
            case LUA_TBOOLEAN:
                if(lua_toboolean(L, -1) != 0)
                    luaL_addchar(&b, *s);
                break;
            default:
                luaL_addchar(&b, *s);
                break;
        }
        lua_pop(L, 1);
        ++s;
    }
    lua_settop(L, 0);
    luaL_pushresult(&b);
    return 1;
}

static const struct luaL_Reg mylib [] =
{
    {"filter",l_filter},
    {"split",l_split},
    /* 使用注册表 */
    {"settrans",l_settrans_reg},
    {"gettrans",l_gettrans_reg},
    {"transliterate",l_transliterate_reg},
    /* 使用上值 */
    {"settrans_up",l_settrans_upvalue},
    {"gettrans_up",l_gettrans_upvalue},
    {"transliterate_up",l_transliterate_upvalue},
    {NULL,NULL},
};

LUAMOD_API int luaopen_mylib(lua_State* L)
{
    luaL_newlib(L,mylib);
    lua_newtable(L);
    luaL_setfuncs(L, mylib, 1);
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