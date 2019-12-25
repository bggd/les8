local c = require("les8.c")

local les8 = {}

les8.shader = require("les8.shader").shader
les8.gfx = require("les8.gfx").gfx

function les8.init()
  c.init()
end

function les8.run(fn)
  local close_request
  repeat
    close_request = c.update()
    fn()
    c.capfps()
  until close_request
  c.shutdown()
end

return les8
