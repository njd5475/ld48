
local LitterBox = require('gameobject'):derive("litterbox")

local img = love.graphics.newImage("litterbox.png")
img:setFilter('nearest', 'nearest')

function LitterBox:_init(x,y)
  require('gameobject')._init(self)
  self.x, self.y = (x or 0), (y or 0)
  self.w, self.h = 50, 50
  self.static = true
  self.scaleX = self.w / img:getWidth()
  self.scaleY = self.h / img:getHeight()
  self.quad = love.graphics.newQuad(0, 0, 18, 18, img:getWidth(), img:getHeight())
end

function LitterBox:draw(game)
  love.graphics.setColor(200, 110, 110, 255)
  love.graphics.draw(img, self.quad, self.x, self.y, 0, self.scaleX, self.scaleY)
end

function LitterBox:adjustToPlatform(p)
  self.y = p:topY()
end

return LitterBox
