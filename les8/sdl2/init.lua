local c = require("les8.c")

local sdl2 = {}

local scancodes = {}

for i = 1, 286 do
  scancodes[i] = false
end

sdl2.SCANCODE = require("les8.sdl2.scancode")

function sdl2.GetKeyboardState()
  c.sdl2_get_keyboard_state(scancodes)
  return scancodes
end

return sdl2
