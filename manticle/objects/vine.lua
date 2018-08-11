require('engine.common')

local Basic = require('objects.basic')
local img = require('thesheet')

local Vine = Basic:derive("Vine")

function Vine:_init(x,y,w,h)
  Basic._init(self, {x=x,y=y,w=w,h=h}, {x=1,y=1,w=16,h=16}, img)
  self.timeTillGrow = love.math.random(1,5)
  self.canGrow = true
end

function Vine:update(game, dt)
  Basic.update(self, game, dt)
  if self.canGrow then
  self.timeTillGrow = self.timeTillGrow - 5*dt
    if self.timeTillGrow <= 0 then
      game:add(Vine(self.x, self.y+self.h, self.w, self.h))
      self.canGrow = false
    end
  end
end

return Vine
