
local MilkAndCookies = require('gameobject'):derive('milkandcookies')

local img = require('thesheet')

function MilkAndCookies:_init(x,y)
  require('gameobject')._init(self)
  self.image = img
  self.quad = love.graphics.newQuad(0, 0, 18, 18, img:getDimensions())
  self.x, self.y = (x or 0), (y or 0)
  self.w, self.h = 50, 50
  self.scaleX = self.w / 18
  self.scaleY = self.h / 18
  self.static = true
end

function MilkAndCookies:draw(game)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.image, self.quad, self.x, self.y, 0, self.scaleX, self.scaleY)
end

return MilkAndCookies
