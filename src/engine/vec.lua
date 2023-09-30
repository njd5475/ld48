
local Vec = require('engine.class')()

function Vec:_init(x, y)
  self.x, self.y = (x or 0), (y or 0)
  self.getX = function(v) return v.x end
  self.getY = function(v) return v.y end
end

function Vec:normalize()
  local mag = self:magnitude()
  return Vec(self.x/mag, self.y/mag)
end

function Vec:magnitude()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec:add(vec)
  return Vec(self.x+vec.x, self.y+vec.y)
end

function Vec:sub(vec)
  return Vec(self.x - vec.x, self.y - vec.y)
end

function Vec:mult(v, w)
  if v and not w then
    if type(v) == 'number' then
      return Vec(self.x*v, self.y*v)
    else
      return Vec(self.x*v.x, self.y*v.y)
    end
  elseif v and w then
    return Vec(self.x*v, self.y*w)
  end
end

function Vec:unwrap()
  return self.x, self.y
end

function Vec:copy()
  return Vec(self.x, self.y)
end

Vec.Zero = Vec(0,0)

return Vec
