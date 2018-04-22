
local LitterBox = require('gameobject'):derive("litterbox")
local Cat = require('cat')
local img = require('thesheet')
img:setFilter('nearest', 'nearest')

function LitterBox:_init(x,y)
  require('gameobject')._init(self)
  self.x, self.y = (x or 0), (y or 0)
  self.w, self.h = 50, 50
  self.static = true
  self.scaleX = self.w / 18
  self.scaleY = self.h / 18
  self.quad = love.graphics.newQuad(18, 0, 18, 18, img:getDimensions())
end

function LitterBox:update(game, dt)
  self.timeout = (self.timeout or 1) - dt
  if self.timeout < 0 then
    game:add(Cat(self.x+self.w/2, self.y-30))
    self.timeout = 1.5
  end
end

function LitterBox:draw(game)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(img, self.quad, self.x, self.y, 0, self.scaleX, self.scaleY)
end

function LitterBox:adjustToPlatform(p)
  self.y = p:topY()
end

return LitterBox
