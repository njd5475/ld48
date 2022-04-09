require('engine.common')

local Basic = require('objects.basic')
local Wall = Basic:derive('Wall')

local img = require('main-sheet')

function Wall:_init(x,y,w,h)
  Basic._init(self, {x=x, y=y, w=w, h=h}, {x=32*4, y=0, w=32, h=32}, img)
end

function Wall:draw(game)
  Basic.draw(self, game)
end

function Wall:isBlocking()
  return true
end

return Wall