
// remember to put libexpat.a into you mingw's lib

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
#include "./expat/expat.h"

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
            closedir(d);
            d = NULL;
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

/* XML Parser */
typedef struct lxp_userdata{
    XML_Parser parser;
    lua_State *L;
    int ref_cb;
}lxp_userdata;

static void f_StartElement(void *ud,const char *name, const char **atts);

static void f_CharData(void *ud, const char *s, int len);

static void f_EndElement(void *ud, const char *name);

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

static int lxp_make_parser(lua_State *L)
{
    XML_Parser p;

    lxp_userdata *xpu = (lxp_userdata*)lua_newuserdata(L, sizeof(lxp_userdata));

    // Initialize
    xpu->parser = NULL;
    xpu->ref_cb = 0;
    // set metatable
    luaL_getmetatable(L, "Expat");
    lua_setmetatable(L, -2);

    // create expat parser
    p = xpu->parser = XML_ParserCreate(NULL);
    if(!p)
      error(L,"XML_ParserCreate failed!");
    // check and save callback table
    luaL_checktype(L, 1, LUA_TTABLE);
    lua_pushvalue(L, 1);
    xpu->ref_cb = luaL_ref(L, LUA_REGISTRYINDEX);    //lua_setuservalue(L, -2);
    // set expat parser
    XML_SetUserData(p, xpu);
    XML_SetElementHandler(p, f_StartElement, f_EndElement);
    XML_SetCharacterDataHandler(p, f_CharData);
    return 1;
}

static int lxp_parse(lua_State *L)
{
    int status;
    size_t len;
    const char *s;
    lxp_userdata *xpu;

    xpu = (lxp_userdata *)luaL_checkudata(L, 1, "Expat");

    luaL_argcheck(L, xpu->parser != NULL, 1, "parser is closed");

    s = luaL_optlstring(L, 2, NULL, &len);

    lua_settop(L, 2);
    lua_rawgeti(L, LUA_REGISTRYINDEX, xpu->ref_cb);//lua_getuservalue(L, 1);

    xpu->L = L;

    status = XML_Parse(xpu->parser, s, (int)len, s == NULL);

    lua_pushboolean(L, status);
    return 1;
}

static void f_CharData(void *ud, const char *s, int len)
{
    lxp_userdata *xpu = (lxp_userdata *)ud;
    lua_State *L = xpu->L;

    lua_getfield(L, 3, "CharacterData");
    if(lua_isnil(L, -1))
    {
        lua_pop(L, 1);
        return;
    }
    lua_pushvalue(L, 1);
    lua_pushlstring(L, s, len);
    lua_call(L, 2, 0);
}

static void f_StartElement(void *ud, const char *name, const char **atts)
{
    lxp_userdata *xpu = (lxp_userdata *)ud;
    lua_State *L = xpu->L;
    lua_getfield(L, 3, "StartElement");
    if (lua_isnil(L, -1))
    {
        lua_pop(L, 1);
        return;
    }
    lua_pushvalue(L, 1);
    lua_pushstring(L, name);

    lua_newtable(L);
    for(; *atts; atts += 2)
    {
        lua_pushstring(L, *(atts + 1));
        lua_setfield(L, -2, *atts);
    }

    lua_call(L, 3, 0);
}

static void f_EndElement(void *ud ,const char *name)
{
    lxp_userdata *xpu = (lxp_userdata *)ud;

    lua_State *L = xpu->L;

    lua_getfield(L, 3, "EndElement");
    if(lua_isnil(L, -1))
    {
        lua_pop(L, 1);
        return;
    }
    lua_pushvalue(L, 1);
    lua_pushstring(L, name);
    lua_call(L, 2, 0);
}

static int lxp_close(lua_State *L)
{
    lxp_userdata *xpu = (lxp_userdata *)luaL_checkudata(L, 1, "Expat");

    if(xpu->parser)
    {
        XML_ParserFree(xpu->parser);
        xpu->parser = NULL;
    }
    if (xpu->ref_cb != 0)
    {
        luaL_unref(L, LUA_REGISTRYINDEX, xpu->ref_cb);
        xpu->ref_cb = 0;
    }
    return 0;
}

static const luaL_Reg lxp_meths[] = {
    {"parse", lxp_parse},
    {"close", lxp_close},
    {"__gc", lxp_close},
    {NULL, NULL},
};

static const luaL_Reg lxp_funcs[] = {
    {"new", lxp_make_parser},
    {NULL, NULL},
};

int luaopen_lxp(lua_State *L)
{
    luaL_newmetatable(L, "Expat");

    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    luaL_setfuncs(L, lxp_meths, 0);

    luaL_newlib(L, lxp_funcs);
    return 1;
}

void luaL_openlxplib(lua_State *L)
{
    luaL_requiref(L,"lxp",luaopen_lxp,1);
    lua_pop(L, 1); 
}

int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
      (L);
    luaL_openlxplib(L);
    if(luaL_dofile(L, "chapter32.lua") != LUA_OK)
    {
        printf("lua error: %s",lua_tostring(L,-1));
    }
    system("Pause");
}