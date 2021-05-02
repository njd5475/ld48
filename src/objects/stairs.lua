require('engine.common')

local Basic = require('objects.basic')
local Stairs = Basic:derive('Stairs')

local img = require('ld48sheet')

function Stairs:_init(x,y,w,h)
  Basic._init(self, {x=x, y=y, w=w, h=h}, {x=16*4, y=0, w=16, h=16}, img)
  self:markCollidable()
end

function Stairs:draw(game)
  Basic.draw(self, game)
end

function Stairs:doCollision(hitObj, game)
  Basic.doCollision(self, hitObj, game)
  if hitObj:is('player') then
    game:current():moveOnDown()
  end
end

return Stairs