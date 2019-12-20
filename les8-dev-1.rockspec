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
    ["les8"] = "les8/les8.lua",
    ["les8.vec3"] = "les8/vec3.lua",
    ["les8.mat3"] = "les8/mat3.lua",
    ["les8.mat4"] = "les8/mat4.lua",
    ["les8.c"] = {
      sources = {"src/les8.cpp"},
      libraries = {"SDL2"}
    }
  }
}