local mat3 = {}

function mat3.identity()
  return {1.0, 0.0, 0.0,
          0.0, 1.0, 0.0,
          0.0, 0.0, 1.0}
end

function mat3.zero()
  return {0.0, 0.0, 0.0,
          0.0, 0.0, 0.0,
          0.0, 0.0, 0.0}
end

function mat3.transpose(m)
  return {m[1], m[4], m[7],
          m[2], m[5], m[8],
          m[3], m[6], m[9]}
end

function mat3.mul(a, b)
  local m = mat3.zero()
  for c = 1, 3 do
    for r = 1, 3 do
      for k = 1, 3 do
        m[3 * c + r - 3] = m[3 * c + r - 3] + (a[3 * k + r - 3] * b[3 * c + k - 3])
      end
    end
  end
  return m
end

return mat3
