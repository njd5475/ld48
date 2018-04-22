
local Platform = require('gameobject'):derive("platform")

function Platform:_init(x,y,w,h)
  require('gameobject')._init(self)
  self.static = true
  self.x, self.y, self.w, self.h = x,y,w,h
  self.boundsX = function(o) return o.x end
  self.boundsY = function(o) return o.y end
  self.boundsWidth = function(o) return o.w end
  self.boundsHeight = function(o) return o.h end
  self.topY = function(o) return o.y end
end

function Platform:draw(game)
  love.graphics.setColor(200, 100, 100, 255)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Platform
