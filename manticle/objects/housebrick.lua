require('engine.common')

local HouseBrick = GameObject:derive("HouseBrick")

local img = require('thesheet')

function HouseBrick:_init(x, y, w, h)
  GameObject._init(self)
  self.img = img
  self.quad = love.graphics.newQuad(19, 1, 16, 16, img:getDimensions())
  self.x, self.y = x, y
  self.w, self.h = w, h
  self.scaleX, self.scaleY = self.w/16, self.h/16
  self.boundsX = function(o) return o.x end
  self.boundsY = function(o) return o.y end
  self.boundsWidth = function(o) return o.w end
  self.boundsHeight = function(o) return o.h end
end

function HouseBrick:draw(game)
  love.graphics.draw(self.img, self.quad, self.x, self.y, 0, self.scaleX, self.scaleY);
end

function HouseBrick:coveredWithVine(game)
  local vines = game:withinRange(self.x+self.w/2, self.y+self.h/2, self.w, "Vine")
  return #vines > 0
end

return HouseBrick
