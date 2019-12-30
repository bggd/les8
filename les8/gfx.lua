local c = require("les8.c")

local les8 = {}

les8.gfx = {}

function les8.gfx.clear(R, G, B, A)
  assert(R >= 0.0 and R <= 1.0)
  assert(G >= 0.0 and G <= 1.0)
  assert(B >= 0.0 and B <= 1.0)
  assert(A >= 0.0 and A <= 1.0)
  c.gfx_clear(R, G, B, A)
end

function les8.gfx.present()
  c.gfx_present()
end

function les8.gfx.set_shader(shader)
  c.gfx_set_shader(shader[1], shader[2])
end

function les8.gfx.set_projection_matrix(matrix)
  assert(#matrix == 16)
  c.gfx_set_projection_matrix(matrix)
end

function les8.gfx.set_texture(texture)
  c.gfx_set_texture(texture[1], texture[2])
end

function les8.gfx.draw_triangles(vertices)
  c.gfx_draw_triangles(vertices)
end

return les8
