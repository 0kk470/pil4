#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern "C"
{
#include "../lua_src/lua.h"
#include "../lua_src/lauxlib.h"
#include "../lua_src/lualib.h"
}

#define BITS_PER_WORD (CHAR_BIT * sizeof(unsigned int))

#define I_WORD(i) ((unsigned int)(i) / BITS_PER_WORD)

#define I_BIT(i) (1 << ((unsigned int)(i) % BITS_PER_WORD))

#define checkarray(L) \
        (BitArray *)luaL_checkudata(L, 1, "LuaBook.array")

typedef struct BitArray
{
    /* data */
    int size;
    unsigned int values[1];
}BitArray;


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

static int newarray(lua_State *L)
{
    int i;
    size_t nbytes;
    BitArray *a;

    int n = (int)luaL_checkinteger(L, 1);
    luaL_argcheck(L, n >=1, 1, "invalid size");
    nbytes = sizeof(BitArray) + I_WORD(n - 1) * sizeof(unsigned int);
    a = (BitArray *)lua_newuserdata(L, nbytes);
    a->size = n;
    for(i = 0; i <= I_WORD(n - 1); i++)
        a->values[i] = 0; 

    luaL_getmetatable(L, "LuaBook.array");
    lua_setmetatable(L, -2);
    return 1;
}

static unsigned int *getparams(lua_State *L, unsigned int *mask)
{
    BitArray *a = checkarray(L);
    int index = (int)luaL_checkinteger(L, 2) - 1;
    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    luaL_argcheck(L, 0 <= index && index < a->size, 2, "index out of range");
    *mask = I_BIT(index);
    return &a->values[I_WORD(index)];
}

static int setarray(lua_State* L)
{
    unsigned int mask;
    unsigned int *entry = getparams(L, &mask);
    luaL_checktype(L, 3, LUA_TBOOLEAN);  // Exercise 31.1
    if(lua_toboolean(L, 3))
        *entry |= mask;
    else
        *entry &= ~mask;
    return 0;
}

static int getarray(lua_State* L)
{
    unsigned int mask;
    unsigned int *entry = getparams(L, &mask);
    lua_pushboolean(L, *entry & mask);
    return 1;
}

static int getsize(lua_State* L)
{
    BitArray *a = checkarray(L);
    luaL_argcheck(L, a != NULL, 1, "'array' expected");
    lua_pushinteger(L, a->size);
    return 1;
}

static int array2string(lua_State* L)
{
    BitArray *a = checkarray(L);
    lua_pushfstring(L, "array(%d)", a->size);
    return 1;
}

static const struct luaL_Reg arraylib [] =
{
    {"new",newarray},
    {"set",setarray},
    {"get",getarray},
    {"size",getsize},
    {NULL,NULL},
};

static const struct luaL_Reg arraylib_metamethods [] =
{
    {"__index", getarray},
    {"__newindex", setarray},
    {"__len" , getsize},
    {"__tostring",array2string},
    {NULL,NULL},
};

LUAMOD_API int luaopen_array(lua_State* L)
{
    luaL_newmetatable(L, "LuaBook.array");
    luaL_setfuncs(L, arraylib_metamethods, 0);
    luaL_newlib(L,arraylib);
    return 1;
}

void luaL_openarray(lua_State* L)
{
    luaL_requiref(L,"array",luaopen_array,1);
    lua_pop(L, 1); 
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    luaL_openarray(L);
    if(luaL_dofile(L, "chapter31.lua") != LUA_OK)
    {
        printf("lua error: %s",lua_tostring(L,-1));
    }
    system("Pause");
}