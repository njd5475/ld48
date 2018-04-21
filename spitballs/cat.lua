
local Cat = require('gameobject'):derive()

local Game = require('game')

function Cat:_init()
  require('gameobject')._init(self)
  self.x, self.y = love.math.random(Game.bounds.w), love.math.random(Game.bounds.h)
end

function Cat:draw(game)
  love.graphics.ellipse("line", self.x, self.y, 20, 20)
end

return Cat
