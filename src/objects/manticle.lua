require('engine.common')

local Basic = require('objects.basic')
local Manticle = Basic:derive("Manticle")

function Manticle:_init(asprite, x, y, w, h)
  Basic._init(self, {x=x, y=y, w=w, h=h}, {x=19,y=1,w=16,h=16}, nil)
  self.sprite = asprite
  self.sprite:loopable()
end

function Manticle:update(game, dt)
  Basic.update(self, game, dt)
  self.sprite:update(game, dt)
end

function Manticle:draw(game)
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.scale(self.scaleX, self.scaleY)
  Basic.draw(self, game)
  self.sprite:draw(game)
  love.graphics.pop()
end

return Manticle
