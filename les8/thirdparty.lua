local c = require("les8.c")

local les8 = {}

les8.thirdparty = {}

function les8.thirdparty.stbi_load_from_memory(buffer)
  local data, w, h, channels = c.stbi_load_from_memory(buffer)
  return data, w, h, channels
end

return les8.thirdparty
