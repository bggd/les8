local c = require("les8.c")

local les8 = {}

les8.shader = {}

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

function les8.shader.create(shader_decl)
  assert(#shader_decl.input_layout > 0)
  assert(#shader_decl.input_layout < 8)

  local flatten_layout = {}
  for _, input in ipairs(shader_decl.input_layout) do
    table.insert(flatten_layout, input.semantic_name)
    table.insert(flatten_layout, input.semantic_index)
    table.insert(flatten_layout, input.num_float)
  end

  local input_layout,
        vertex_shader,
        pixel_shader = c.shader_create(flatten_layout,
                                       shader_decl.vertex_shader,
                                       shader_decl.pixel_shader)

  return {input_layout, vertex_shader, pixel_shader}
end

function les8.shader.destroy(shader)
  assert(type(shader[1]) == 'userdata')
  assert(type(shader[2]) == 'userdata')
  assert(type(shader[3]) == 'userdata')

  c.shader_destroy(shader[1], shader[2], shader[3])
end

return les8
