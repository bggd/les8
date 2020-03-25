local c = require("les8.c")

local gfx = {}

gfx.shader = {}

--[[
shader_decl = {
  input_layout = {
    {
      semantic_name = '',
      sematic_index = 0,
      num_float = 0
    }
  },
  vertex_shader = '',
  pixel_shader = ''
}
--]]

function gfx.shader.create(shader_decl)
  assert(#shader_decl.input_layout > 0)
  assert(#shader_decl.input_layout <= 8)

  local flatten_layout = {}
  for _, input in ipairs(shader_decl.input_layout) do
    table.insert(flatten_layout, input.semantic_name)
    table.insert(flatten_layout, input.semantic_index)
    table.insert(flatten_layout, input.num_float)
  end

  local id,
        generation
        = c.shader_create(flatten_layout,
                          shader_decl.vertex_shader,
                          shader_decl.pixel_shader)

  return {id, generation}
end

function gfx.shader.destroy(shader)
  c.shader_destroy(shader[1], shader[2])
end

return gfx.shader
