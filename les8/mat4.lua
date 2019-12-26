local vec3 = require("les8.vec3")
local mat4 = {}

local function deg2rad(x)
  -- x * (math.pi / 180.0)
  return x * 0.017453292519943
end

function mat4.identity()
  return {
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0
  }
end

function mat4.zero()
  return {
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0
  }
end

function mat4.transpose(m)
  return {
    m[1], m[5], m[9],  m[13],
    m[2], m[6], m[10], m[14],
    m[3], m[7], m[11], m[15],
    m[4], m[8], m[12], m[16]
  }
end

function mat4.mul(a, b)
  local m = mat4.zero()
  for c = 1, 4 do
    for r = 1, 4 do
      for k = 1, 4 do
        m[4 * c + r - 4] = m[4 * c + r - 4] + (a[4 * k + r - 4] * b[4 * c + k - 4])
      end
    end
  end
  return m
end

function mat4.translate(v)
  return {
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    v[1], v[2], v[3], 1.0
  }
end

function mat4.scale(v)
  return {
    v[1], 0.0, 0.0, 0.0,
    0.0, v[2], 0.0, 0.0,
    0.0, 0.0, v[3], 0.0,
    0.0, 0.0, 0.0, 1.0
  }
end

function mat4.rotate(v, angle)
  angle = deg2rad(angle)
  local c = math.cos(angle)
  local s = math.sin(angle)
  local t = 1.0 - c

  return {
    t*(v[1]*v[1])+c, t*v[1]*v[2]+s*v[3], t*v[1]*v[3]-s*v[2], 0.0,
    t*v[1]*v[2]-s*v[3], t*(v[2]*v[2])+c, t*v[2]*v[3]+s*v[1], 0.0,
    t*v[1]*v[3]+s*v[2], t*v[2]*v[3]-s*v[1], t*(v[3]*v[3])+c, 0.0,
    0.0, 0.0, 0.0, 1.0
  }
end

-- w == 1 point
-- w == 0 vector
function mat4.xform_vec3(m, v, w)
  return {
    v[1]*m[1]+v[2]*m[5]+v[3]*m[9] +w*m[13],
    v[1]*m[2]+v[2]*m[6]+v[3]*m[10]+w*m[14],
    v[1]*m[3]+v[2]*m[7]+v[3]*m[11]+w*m[15],
  }
end

function mat4.lookat(pos, target, up)
  local forward = vec3.normalize(vec3.sub(target, pos))
  local right = vec3.normalize(vec3.cross(up, forward))
  local newup = vec3.cross(forward, right)

  return {
    right[1], newup[1], forward[1], 0.0,
    right[2], newup[2], forward[2], 0.0,
    right[3], newup[3], forward[3], 0.0,
    -vec3.dot(right, pos),
    -vec3.dot(newup, pos),
    -vec3.dot(forward, pos),
    1.0
  }
end

function mat4.ortho(left, right, bottom, top, near, far)
  local _11 = 2.0 / (right - left)
  local _22 = 2.0 / (top - bottom)
  local _33 = 1.0 / (far - near)
  local _41 = (left + right) / (left - right)
  local _42 = (top + bottom) / (bottom - top)
  local _43 = near / (near - far)

  return {
    _11, 0.0, 0.0, 0.0,
    0.0, _22, 0.0, 0.0,
    _11, 0.0, _33, 0.0,
    _41, _42, _43, 1.0
  }
end

return mat4
