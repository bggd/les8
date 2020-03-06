#include <stdint.h>
extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}

#include "../moge/cppes8/src/cppes8.hpp"
#include "../moge/cppes8/src/shader.cpp"
#include "../moge/cppes8/src/texture.cpp"

#define STB_IMAGE_IMPLEMENTATION
#include "../thirdparty/stb/stb_image.h"

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
    cppes8::shader::InputLayout& input = array_of_input_layout[i / 3];
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
les8c_texture_create(lua_State* L)
{
  cppes8::texture::TextureDecl tex_decl;

  tex_decl.width = luaL_checkinteger(L, 1);
  tex_decl.height = luaL_checkinteger(L, 2);
  tex_decl.rgba = (const uint8_t*)luaL_checkstring(L, 3);

  cppes8::texture::TextureHandle handle = cppes8::texture::create(g_gamelib, tex_decl);

  lua_pushinteger(L, handle.id);
  lua_pushinteger(L, handle.generation);
  return 2;
}

static int
les8c_texture_destroy(lua_State* L)
{
  cppes8::texture::TextureHandle handle;
  handle.id = luaL_checkinteger(L, 1);
  handle.generation = luaL_checkinteger(L, 2);
  cppes8::texture::destroy(g_gamelib, handle);
  return 0;
}

static int
les8c_gfx_clear(lua_State* L)
{
  float R, G, B, A;
  R = luaL_checknumber(L, 1);
  G = luaL_checknumber(L, 2);
  B = luaL_checknumber(L, 3);
  A = luaL_checknumber(L, 4);
  cppes8::gfx::clear(g_gamelib, R, G, B, A);
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
les8c_gfx_set_projection_matrix(lua_State* L)
{
  float matrix[16];
  size_t len = lua_rawlen(L, 1);

  for (size_t i = 0; i < len; ++i) {
    lua_rawgeti(L, 1, i + 1);
    matrix[i] = lua_tonumber(L, -1);
    lua_pop(L, 1);
  }

  cppes8::gfx::set_projection_matrix(g_gamelib, matrix);

  return 0;
}

static int
les8c_gfx_set_texture(lua_State* L)
{
  cppes8::texture::TextureHandle handle;
  handle.id = luaL_checkinteger(L, 1);
  handle.generation = luaL_checkinteger(L, 2);
  cppes8::gfx::set_texture(g_gamelib, handle);
  return 0;
}

static int
les8c_gfx_draw_triangles(lua_State* L)
{
  static float vertices[CPPES8_CONFIG_MAX_VERTICES];

  size_t len = lua_rawlen(L, 1);
  assert(len < CPPES8_CONFIG_MAX_VERTICES);

  for (size_t i = 0; i < len; ++i) {
    lua_rawgeti(L, 1, i + 1);
    vertices[i] = lua_tonumber(L, -1);
    lua_pop(L, 1);
  }

  cppes8::gfx::draw_triangles(g_gamelib, vertices, len);

  return 0;
}

static int
les8c_stbi_load_from_memory(lua_State* L)
{
  size_t len;
  const uint8_t* buffer = (const uint8_t*)luaL_checklstring(L, 1, &len);
  assert(len < INT32_MAX);

  int x, y, c;
  const char* decoded_data = (const char*)stbi_load_from_memory(buffer, len, &x, &y, &c, 0);

  lua_pushlstring(L, decoded_data, sizeof(char) * x * y * c);
  lua_pushinteger(L, x);
  lua_pushinteger(L, y);
  lua_pushinteger(L, c);

  return 4;
}

static int
les8c_sdl2_get_keyboard_state(lua_State* L)
{
  const UINT8* state = SDL_GetKeyboardState(NULL);

  size_t len = lua_rawlen(L, 1);

  for (size_t i = 0; i < len; ++i) {
    lua_pushboolean(L, state[i + 1]);
    lua_rawseti(L, 1, i + 1);
  }

  return 1;
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
    {"texture_create", les8c_texture_create},
    {"texture_destroy", les8c_texture_destroy},
    {"gfx_clear", les8c_gfx_clear},
    {"gfx_present", les8c_gfx_present},
    {"gfx_set_shader", les8c_gfx_set_shader},
    {"gfx_set_projection_matrix", les8c_gfx_set_projection_matrix},
    {"gfx_set_texture", les8c_gfx_set_texture},
    {"gfx_draw_triangles", les8c_gfx_draw_triangles},
    {"stbi_load_from_memory", les8c_stbi_load_from_memory},
    {"sdl2_get_keyboard_state", les8c_sdl2_get_keyboard_state},
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
