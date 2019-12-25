extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

#include "../moge/cppes8/src/cppes8.hpp"
#include "../moge/cppes8/src/shader.cpp"

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

static int
les8c_shader_create(lua_State* L)
{
  cppes8::shader::InputLayout array_of_input_layout[8] = {};
  size_t len = lua_rawlen(L, 1);
  for (size_t i = 0; i < len; i += 3) {
    cppes8::shader::InputLayout& input = array_of_input_layout[i];
    lua_rawgeti(L, 1, i + 1);
    input.semantic_name = lua_tostring(L, -1);
    lua_rawgeti(L, 1, i + 2);
    input.semantic_index = (uint32_t)lua_tointeger(L, -1);
    lua_rawgeti(L, 1, i + 3);
    input.num_float = (uint32_t)lua_tointeger(L, -1);
    lua_pop(L, 2);
  }

  cppes8::shader::ShaderDecl shader_decl;
  shader_decl.array_of_input_layout = array_of_input_layout;
  shader_decl.num_array_of_input_layout = len / 3;
  shader_decl.vertex_shader = lua_tolstring(L, 2, &shader_decl.vertex_shader_len);
  shader_decl.pixel_shader = lua_tolstring(L, 3, &shader_decl.pixel_shader_len);
  cppes8::shader::ShaderHandle handle = cppes8::shader::create(g_gamelib, shader_decl);

  lua_pushinteger(L, handle.id);
  lua_pushinteger(L, handle.generation);
  return 2;
}

static int
les8c_shader_destroy(lua_State* L)
{
  cppes8::shader::ShaderHandle handle;
  handle.id = luaL_checkinteger(L, 1);
  handle.generation = luaL_checkinteger(L, 2);
  cppes8::shader::destroy(g_gamelib, handle);
  return 0;
}

static int
les8c_gfx_clear(lua_State* L)
{
  cppes8::gfx::clear(g_gamelib, 0.0f, 0.0f, 0.0f, 1.0);
  return 0;
}

static int
les8c_gfx_present(lua_State* L)
{
  cppes8::gfx::present(g_gamelib);
  return 0;
}

static int
les8c_gfx_set_shader(lua_State* L)
{
  cppes8::shader::ShaderHandle handle;
  handle.id = luaL_checkinteger(L, 1);
  handle.generation = luaL_checkinteger(L, 2);
  cppes8::gfx::set_shader(g_gamelib, handle);
  return 0;
}

static int
les8c_gfx_draw_triangles(lua_State* L)
{
  static float vertices[CPPES8_CONFIG_MAX_VERTICES];

  size_t len = lua_rawlen(L, 1);

  for (size_t i = 0; i < len; ++i) {
    lua_rawgeti(L, 1, i + 1);
    vertices[i] = (float)lua_tonumber(L, -1);
    lua_pop(L, 1);
  }

  cppes8::gfx::draw_triangles(g_gamelib, vertices, len);

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
    {"shader_create", les8c_shader_create},
    {"shader_destroy", les8c_shader_destroy},
    {"gfx_clear", les8c_gfx_clear},
    {"gfx_present", les8c_gfx_present},
    {"gfx_set_shader", les8c_gfx_set_shader},
    {"gfx_draw_triangles", les8c_gfx_draw_triangles},
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
