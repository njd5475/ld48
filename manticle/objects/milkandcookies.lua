require('engine.common')
local MilkAndCookies = GameObject:derive('milkandcookies')

local img = require('thesheet')

function MilkAndCookies:_init(x,y)
  GameObject._init(self)
  self.image = img
  self.quad = love.graphics.newQuad(0, 0, 18, 18, img:getDimensions())
  self.x, self.y = (x or 0), (y or 0)
  self.w, self.h = 50, 50
  self.scaleX = self.w / 18
  self.scaleY = self.h / 18
  self:stop()
  self.boundsX = function(o) return o.x-o.w/2 end
  self.boundsY = function(o) return o.y-o.h/2 end
  self.boundsWidth = function(o) return o.w end
  self.boundsHeight = function(o) return o.h end
  self.boundsCenter = function(o) return o.x, o.y end
end

function MilkAndCookies:draw(game)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.image, self.quad, self.x, self.y, 0, self.scaleX, self.scaleY)
end

return MilkAndCookies
