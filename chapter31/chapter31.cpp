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

#define checkarray(L, n) \
        (BitArray *)luaL_checkudata(L, n, "LuaBook.array")

#define checkarrayindex(bitarray,i) (bitarray->values[I_WORD(i)] & I_BIT(i)) 

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
    BitArray *a = checkarray(L, 1);
    int index = (int)luaL_checkinteger(L, 2) - 1;
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

static int getsize(lua_State *L)
{
    BitArray *a = checkarray(L, 1);
    lua_pushinteger(L, a->size);
    return 1;
}


/* Exercise 31.2 ~ Exercise 31.4 */
char buffer[25];
static int array2string(lua_State *L)
{
    BitArray *a = checkarray(L, 1);
    luaL_Buffer b;
    luaL_buffinit(L, &b);
    luaL_addstring(&b, "=== array start ===\n");
    sprintf(buffer, "size : %d\n", a->size);
    luaL_addstring(&b, buffer);
    for(int i = 0; i < a->size; i++)
    {
        sprintf(buffer,"[%d]  =  %s\n\0", i + 1, checkarrayindex(a,i) ? "true" : "false");
        luaL_addstring(&b, buffer);
    }
    luaL_addstring(&b, "=== array end ===\n");
    luaL_pushresult(&b);
    return 1;
}

static int getintersection(lua_State *L)
{
    BitArray *a = checkarray(L, 1);
    BitArray *b = checkarray(L, 2);
    int len = __min(a->size,b->size);
    lua_pushcfunction(L, newarray);
    lua_pushinteger(L, len);
    if (lua_pcall(L, 1, 1, 0) == LUA_OK)
    {
        BitArray *c = (BitArray *)lua_touserdata(L, -1);
        for (int i = 0; i < len; i++)
        {
            if (checkarrayindex(a, i) && checkarrayindex(b, i))
                c->values[I_WORD(i)] |= I_BIT(i);
            else
                c->values[I_WORD(i)] &= ~I_BIT(i);
        }
    }
    else
    {
        error(L,"create new array failed:",lua_tostring(L, -1));
    }  
    return 1;
}

static int getunion(lua_State *L)
{
    BitArray *a = checkarray(L, 1);
    BitArray *b = checkarray(L, 2);
    int len = __max(a->size,b->size);
    lua_pushcfunction(L, newarray);
    lua_pushinteger(L, len);
    if (lua_pcall(L, 1, 1, 0) == LUA_OK)
    {
        BitArray *tmp = a->size < b->size ? a : b;
        BitArray *c = (BitArray *)lua_touserdata(L, -1);
        int i;
        for (i = 0; i < tmp->size; i++)
        {
            if (checkarrayindex(a, i) || checkarrayindex(b, i))
                c->values[I_WORD(i)] |= I_BIT(i);
            else
                c->values[I_WORD(i)] &= ~I_BIT(i);
        }
        for (; i < len; i++)
            c->values[I_WORD(i)] = tmp->values[I_WORD(i)];
    }
    else
    {
        error(L, "create new array failed:", lua_tostring(L, -1));
    }
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
    {"__add",getintersection},
    {"__mul",getunion},
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