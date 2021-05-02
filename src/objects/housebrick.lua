require('engine.common')

local Basic = require('objects.basic')
local HouseBrick = Basic:derive("HouseBrick")

local img = require('thesheet')

function HouseBrick:_init(x, y, w, h)
  Basic._init(self, {x=x,y=y,w=w,h=h}, {x=19,y=1,w=16,h=16}, img)
end

function HouseBrick:coveredWithVine(game)
  local vines = game:withinRange(self.x+self.w/2, self.y+self.h/2, self.w, "Vine")
  return #vines > 0
end

return HouseBrick
