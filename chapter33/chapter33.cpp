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
    {
        int t = lua_type(send, i);
        switch (t)
        {
            case LUA_TSTRING:
            {
                lua_pushstring(rec, lua_tostring(send, i));
                break;
            }
            case LUA_TNUMBER:
            {
                lua_pushnumber(rec, lua_tonumber(send, i));
                break;
            }
            case LUA_TBOOLEAN:
            {
                lua_pushboolean(rec, lua_toboolean(send, i));
                break;
            }
            case LUA_TFUNCTION:
            {
                lua_pushcfunction(rec, lua_tocfunction(send, i));
                break;
            }
            case LUA_TUSERDATA:
            {
                lua_pushlightuserdata(rec, lua_touserdata(send, i));
                break;
            }
            case LUA_TLIGHTUSERDATA:
            {
                lua_pushlightuserdata(rec, lua_touserdata(send, i));
                break;
            }
            case LUA_TTHREAD:
            {
                lua_pushthread(lua_tothread(send, i));
                break;
            }
            case LUA_TNIL:
            {
                lua_pushnil(rec);
                break;
            }
            case LUA_TTABLE:
            {
                break;
            }
            default:
                break;
        }
    }
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

static int ll_send(lua_State *L)
{
    Proc *p;
    const char *channel = luaL_checkstring(L, 1);
    pthread_mutex_lock(&kernel_access);
    p = searchmatch(channel, &waitreceive);
    if(p)
    {
        movevalues(L, p->L);
        p->channel = NULL;
        pthread_cond_signal(&p->cond);
    }
    else
    {
        waitonlist(L, channel, &waitsend);
    }
    pthread_mutex_unlock(&kernel_access);
    return 0;
}

static int ll_receive(lua_State *L)
{
    Proc *p;
    const char *channel = luaL_checkstring(L, 1);
    lua_settop(L, 1);

    pthread_mutex_lock(&kernel_access);
    p = searchmatch(channel, &waitsend);
    if(p)
    {
        movevalues(p->L, L);
        p->channel = NULL;
        pthread_cond_signal(&p->cond);
    }
    else
    {
        waitonlist(L, channel, &waitreceive);
    }
    
}


int luaopen_lproc(lua_State *L);

static void *ll_thread(void *arg)
{
    lua_State *L = (lua_State *)arg;
    Proc *self;

    luaL_openlibs(L);
    luaL_requiref(L, "lproc", luaopen_lproc, 1);
    lua_pop(L, 1);
    self = (Proc *)lua_newuserdata(L, sizeof(Proc));
    lua_setfield(L, LUA_REGISTRYINDEX, "_SELF");
    self->L = L;
    self->thread = pthread_self();
    self->channel = NULL;
    pthread_cond_init(&self->cond, NULL);

    if(lua_pcall(L, 0, 0, 0) != LUA_OK)
        error(L, "thread error: %s", lua_tostring(L, -1));

    pthread_cond_destroy(&getself(L)->cond);
    lua_close(L);
    return NULL; 
}

static int ll_start(lua_State *L)
{
    pthread_t thread;
    const char *chunk = luaL_checkstring(L, 1);
    lua_State *L1 = luaL_newstate();

    if(L1 == NULL)
        error(L, "unable to create new state");
    if(luaL_loadstring(L1, chunk) != LUA_OK)
        error(L, "error in thread body: %s", lua_tostring(L1, -1));
    if(pthread_create(&thread, NULL, ll_thread, L1) != LUA_OK)
        error(L, "unable to create new thread"); 
    pthread_detach(thread);
    return 0;
}

static int ll_exit(lua_State *L)
{
    pthread_exit(NULL);
    return 0;
}

static const struct luaL_Reg ll_funcs[] =
{
    {"start", ll_start},
    {"send", ll_send},
    {"receive", ll_receive},
    {"exit", ll_exit},
    {NULL, NULL},
};

LUAMOD_API int luaopen_lproc(lua_State* L)
{
    luaL_newlib(L, ll_funcs);
    return 1;
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    luaL_requiref(L, "lproc", luaopen_lproc, 1);
    lua_pop(L, 1);
    if(luaL_dofile(L, "chapter33.lua") != LUA_OK)
    {
        printf("lua error: %s",lua_tostring(L,-1));
    }
    system("Pause");
}