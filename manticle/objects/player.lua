require('engine.common')
local Basic = require('objects.basic')
local Player = Basic:derive("player")

local img = love.graphics.newImage("images/human1.png")

function Player:_init(x,y,w,h)
  Basic._init(self, {x=x,y=y,w=w,h=h}, {x=0,y=0,w=16,h=32}, img)
  self._speed = 100
end

function Player:update(game, dt)

end

function Player:speed()
  return self._speed
end

return Player
