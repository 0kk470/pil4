#include <pthread.h>

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

typedef struct Proc
{
    lua_State *L;
    pthread_t thread;
    pthread_cond_t cond;
    const char *channel;
    Proc *previous, *next;
} Proc;

static Proc *waitsend = NULL;
static Proc *waitreceive = NULL;

static pthread_mutex_t kernel_access = PTHREAD_MUTEX_INITIALIZER;

static Proc* getself(lua_State *L)
{
    Proc *p;
    lua_getfield(L, LUA_REGISTRYINDEX, "_SELF");
    p = (Proc *)lua_touserdata(L, -1);
    lua_pop(L, 1);
    return p;
} 

static void movevalues(lua_State* send, lua_State* rec)
{
    int n = lua_gettop(send);
    luaL_checkstack(rec, n, "too many results");
    for(int i = 2; i <= n; i++)
        lua_pushstring(rec, lua_tostring(send, i));
}

static Proc* searchmatch(const char *channel, Proc **list)
{
    Proc *node;
    for(node = *list; node != NULL; node = node->next)
    {
        if(strcmp(channel, node->channel) == 0)
        {
            if(*list == node)
                *list = (node->next == node) ? NULL : node->next;
            node->previous->next = node->next;
            node->next->previous = node->previous;
            return node;
        }
    }
    return NULL;
}

static void waitonlist(lua_State *L, const char *channel, Proc **list)
{
    Proc *p = getself(L);
    if(*list == NULL)
    {
        *list = p;
        p->previous = p->next = p;
    }
    else
    {
        p->previous = (*list)->previous;
        p->next = *list;
        p->previous->next = p->next->previous = p;
    }
    
    p->channel = channel;
    do{
        pthread_cond_wait(&p->cond, &kernel_access);
    }while(p->channel);
}

static const struct luaL_Reg mylib [] =
{
    {NULL,NULL},
};

LUAMOD_API int luaopen_mylib(lua_State* L)
{
    luaL_newlib(L, mylib);
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
    if(luaL_dofile(L, "chapter33.lua") != LUA_OK)
    {
        printf("lua error: %s",lua_tostring(L,-1));
    }
    system("Pause");
}