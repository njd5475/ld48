
local Cat = require('gameobject'):derive("cat")

local Game = require('game')

function Cat:_init()
  require('gameobject')._init(self)
  self.x, self.y = love.math.random(Game.bounds.w), love.math.random(Game.bounds.h)

  self.boundsX = function(o) return o.x end
  self.boundsY = function(o) return o.y end
  self.boundsWidth = function(o) return 20 end
  self.boundsHeight = function(o) return 20 end
end

function Cat:draw(game)
  love.graphics.ellipse("line", self.x, self.y, 20, 20)
end

return Cat
