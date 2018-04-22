
local machine = require('gameobject'):derive("spitballmachine")

local Vec = require('vec')

function machine:_init()
  require('gameobject')._init(self)
  self.reloadTime = 0.5
  self.height = 70
  self.w = 20
  self.h = 20
  self.boundsX = function(o) return o.x-o.w/2 end
  self.boundsY = function(o) return o.y-o.h/2 end
  self.boundsWidth = function(o) return o.w end
  self.boundsHeight = function(o) return o.h end
  self.boundsCenter = function(o) return o.x, o.y end
  self.feet = function(o) return {{x=o.x, y=o.y+o.height}} end
end

function machine:update(game, dt)
  self:shouldShootCats(game, dt)
end

function machine:draw(game)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.line(self.x, self.y, self.x, self.y + self.height)
  love.graphics.ellipse("fill", self.x, self.y, self.w, self.h)

end

function machine:drawIcon(game)

end

function machine:place(x,y,game)
  self.x, self.y = x, y
  game:add(self)
end

function machine:shouldShootCats(game, dt)
  self.timeout = (self.timeout or 0) - dt
  if self.timeout < 0 then
    local myVec = Vec(self.x, self.y)
    local catsNearBy = game:withinRange(self.x, self.y, 200*200, 'cat')
    for _, c in pairs(catsNearBy) do
      local dir = Vec(c:boundsX(), c:boundsY()):sub(myVec):normalize()
      local sb = require('spitball')(self.x, self.y, dir.x, dir.y)
      sb.static = true
      sb.speed = 500
      game:add(sb)
    end
    self.timeout = self.reloadTime
  end
end

function machine:adjustToPlatform(p)
  self.y = p:topY() - self.height
end

return machine
