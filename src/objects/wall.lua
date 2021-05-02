require('engine.common')

local Basic = require('objects.basic')
local Wall = Basic:derive('Wall')

local img = require('ld48sheet')

function Wall:_init(x,y,w,h)
  Basic._init(self, {x=x, y=y, w=w, h=h}, {x=16*2, y=0, w=16, h=16}, img)
end

function Wall:draw(game)
  Basic.draw(self, game)
end

function Wall:isBlocking()
  return true
end

return Wall