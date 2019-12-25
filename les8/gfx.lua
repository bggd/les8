local c = require("les8.c")

local les8 = {}

les8.gfx = {}

function les8.gfx.clear()
  c.gfx_clear()
end

function les8.gfx.present()
  c.gfx_present()
end

function les8.gfx.set_shader(shader)
  c.gfx_set_shader(shader[1], shader[2])
end

function les8.gfx.draw_triangles(vertices)
  c.gfx_draw_triangles(vertices)
end

return les8
