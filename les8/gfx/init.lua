local c = require("les8.c")

gfx = {}
gfx.shader = require("les8.gfx.shader")
gfx.texture = require("les8.gfx.texture")

function gfx.clear(R, G, B, A)
  assert(R >= 0.0 and R <= 1.0)
  assert(G >= 0.0 and G <= 1.0)
  assert(B >= 0.0 and B <= 1.0)
  assert(A >= 0.0 and A <= 1.0)
  c.gfx_clear(R, G, B, A)
end

function gfx.present()
  c.gfx_present()
end

function gfx.set_shader(shader)
  c.gfx_set_shader(shader[1], shader[2])
end

function gfx.set_projection_matrix(matrix)
  assert(#matrix == 16)
  c.gfx_set_projection_matrix(matrix)
end

function gfx.set_texture(texture)
  c.gfx_set_texture(texture[1], texture[2])
end

function gfx.draw_triangles(vertices)
  c.gfx_draw_triangles(vertices)
end

return gfx
