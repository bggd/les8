local c = require("les8.c")

local les8 = {}

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
