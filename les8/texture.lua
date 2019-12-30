local c = require("les8.c")

local les8 = {}

les8.texture = {}

--[[
texture_decl = {
  width = 0,
  height = 0,
  data = ""
}
--]]

function les8.texture.create(texture_decl)
  assert(texture_decl.width > 0)
  assert(texture_decl.height > 0)
  assert(#texture_decl.data > 0)

  local id,
        generation = c.texture_create(texture_decl.width,
                                      texture_decl.height,
                                      texture_decl.data)
  return {id, generation}
end

function les8.texture.destroy(texture)
  c.texture_destroy(texture[1], texture[2])
end

return les8.texture
