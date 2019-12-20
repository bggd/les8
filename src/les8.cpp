extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

#include "../moge/cppes8/src/cppes8.hpp"

#include <SDL.h>

#if LUA_VERSION_NUM < 502
#define lua_rawlen(L,i) lua_objlen(L,(i))
#endif


static cppes8::CPPES8 g_gamelib;

static int
les8c_init(lua_State* L)
{
  cppes8::init(g_gamelib);
  return 0;
}

static int
les8c_shutdown(lua_State* L)
{
  cppes8::shutdown(g_gamelib);
  return 0;
}

static int
les8c_update(lua_State* L)
{
  SDL_Event ev;
  while (cppes8::sdl2::poll_event(g_gamelib.sdl2, &ev)) {}
  lua_pushboolean(L, g_gamelib.sdl2.has_close_request);
  return 1;
}

static int
les8c_capfps(lua_State* L)
{
  SDL_Delay(20);
  return 0;
}

extern "C" {
#ifdef _WIN32
__declspec(dllexport)
#endif
int
luaopen_les8_c(lua_State* L)
{
  luaL_Reg les8[] = {
    {"init", les8c_init},
    {"shutdown", les8c_shutdown},
    {"update", les8c_update},
    {"capfps", les8c_capfps},
    {NULL, NULL}
  };
#if LUA_VERSION_NUM < 502
  luaL_register(L, "les8.c", les8);
#else
  luaL_newlib(L, les8);
#endif
  return 1;
}

} // extern "C"
