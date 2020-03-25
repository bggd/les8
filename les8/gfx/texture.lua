local c = require("les8.c")

local gfx = {}

gfx.texture = {}

--[[
texture_decl = {
  width = 0,
  height = 0,
  data = ""
}
--]]

function gfx.texture.create(texture_decl)
  assert(texture_decl.width > 0)
  assert(texture_decl.height > 0)
  assert(#texture_decl.data > 0)

  local id,
        generation = c.texture_create(texture_decl.width,
                                      texture_decl.height,
                                      texture_decl.data)
  return {id, generation}
end

function gfx.texture.destroy(texture)
  c.texture_destroy(texture[1], texture[2])
end

return gfx.texture
