local vec3 = {}

function vec3.add(a, b)
  local v = {0.0, 0.0, 0.0}
  for i = 1, 3 do
    v[i] = a[i] + b[i]
  end
  return v
end

function vec3.sub(a, b)
  local v = {0.0, 0.0, 0.0}
  for i = 1, 3 do
    v[i] = a[i] - b[i]
  end
  return v
end

function vec3.mul(a, b)
  local v = {0.0, 0.0, 0.0}
  for i = 1, 3 do
    v[i] = a[i] * b[i]
  end
  return v
end

function vec3.mul_scalar(a, scalar)
  local v = {0.0, 0.0, 0.0}
  for i = 1, 3 do
    v[i] = a[i] * scalar
  end
  return v
end

function vec3.dot(a, b)
  local dot = 0
  for i = 1, 3 do
    dot = dot + a[i] * b[i]
  end
  return dot
end

function vec3.length(v)
  return math.sqrt(vec3.dot(v, v))
end

function vec3.length2(v)
  return vec3.dot(v, v)
end

function vec3.normalize(v)
  local n = {0.0, 0.0, 0.0}
  local len = 1.0 / vec3.length(v)
  for i = 1, 3 do
    n[i] = v[i] * len
  end
  return n
end

function vec3.cross(a, b)
  local v = {0.0, 0.0, 0.0}
  v[1] = a[2] * b[3] - a[3] * b[2]
  v[2] = a[3] * b[1] - a[1] * b[3]
  v[3] = a[1] * b[2] - a[2] * b[1]
  return v
end

return vec3
