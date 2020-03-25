package = "les8"

version = "dev-1"

source = {
  url = "git://github.com/bggd/les8.git"
}

description = {
 homepage = "https://github.com/bggd/les8",
 license = "MIT"
}

dependencies = {
  "lua >= 5.1"
}

build = {
  type = "builtin",
  modules = {
    ["les8"] = "les8/init.lua",
    ["les8.gfx"] = "les8/gfx/init.lua",
    ["les8.gfx.shader"] = "les8/gfx/shader.lua",
    ["les8.gfx.texture"] = "les8/gfx/texture.lua",
    ["les8.gmath"] = "les8/gmath/init.lua",
    ["les8.gmath.vec3"] = "les8/gmath/vec3.lua",
    ["les8.gmath.mat3"] = "les8/gmath/mat3.lua",
    ["les8.gmath.mat4"] = "les8/gmath/mat4.lua",
    ["les8.gmath.util"] = "les8/gmath/util.lua",
    ["les8.thirdparty"] = "les8/thirdparty.lua",
    ["les8.sdl2"] = "les8/sdl2/init.lua",
    ["les8.sdl2.scancode"] = "les8/sdl2/scancode.lua",
    ["les8.c"] = {
      sources = {"src/les8.cpp"},
      libraries = {"SDL2"}
    }
  }
}
