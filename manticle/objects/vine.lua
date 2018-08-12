require('engine.common')

local Basic = require('objects.basic')
local img = require('thesheet')

local Vine = Basic:derive("Vine")

function Vine:_init(x,y,w,h,grow)
  Basic._init(self, {x=x,y=y,w=w,h=h}, {x=1,y=1,w=16,h=16}, img)
  self.timeTillGrow = love.math.random(1,5)
  self.canGrow = true
  self.grow = grow
  self.grow.duration = self.timeTillGrow
  self.grow.counter = self.grow.duration
end

function Vine:draw(game)
  if not self.grow:completed() and self.canGrow then
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.scale(self.scaleX, self.scaleY)
    self.grow:draw(game)
    love.graphics.pop()
  else
    Basic.draw(self, game)
  end
end

function Vine:update(game, dt)
  Basic.update(self, game, dt)
  if self.canGrow then
    self.grow:update(game, dt)
    self.timeTillGrow = self.timeTillGrow - 5*dt
    if self.timeTillGrow <= 0 and self.grow:completed() then
      self.grow:start()
      game:add(Vine(self.x, self.y+self.h, self.w, self.h, self.grow))
      self.canGrow = false
    end
  end
end

return Vine
