
local Vec = require('class')()

function Vec:_init(x, y)
  self.x, self.y = (x or 0), (y or 0)
end

function Vec:normalize()
  local mag = self:magnitude()
  return Vec(self.x/mag, self.y/mag)
end

function Vec:magnitude()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec:sub(vec)
  return Vec(self.x - vec.x, self.y - vec.y)
end

return Vec
