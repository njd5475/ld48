require('engine.common')

local img = require('thesheet')

local Vine = GameObject:derive("Vine")

function Vine:_init(x,y,w,h)
  GameObject._init(self)
  self.img = img
  self.quad = love.graphics.newQuad(1, 1, 16, 16, img:getDimensions())
  self.x, self.y = x, y
  self.w, self.h = w, h
  self.scaleX, self.scaleY = self.w/16, self.h/16
  self.timeTillGrow = love.math.random(1,5)
  self.canGrow = true
  self.boundsX = function(o) return o.x end
  self.boundsY = function(o) return o.y end
  self.boundsWidth = function(o) return o.w end
  self.boundsHeight = function(o) return o.h end
end

function Vine:draw(game)
  love.graphics.draw(self.img, self.quad, self.x, self.y, 0, self.scaleX, self.scaleY)
end

function Vine:update(game, dt)
  if self.canGrow then
  self.timeTillGrow = self.timeTillGrow - 5*dt
    if self.timeTillGrow <= 0 then
      game:add(Vine(self.x, self.y+self.h, self.w, self.h))
      self.canGrow = false
    end
  end
end

return Vine
