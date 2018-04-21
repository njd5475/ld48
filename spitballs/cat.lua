
local Cat = require('gameobject'):derive("cat")

local Game = require('game')

function Cat:_init()
  require('gameobject')._init(self)
  self.x, self.y = love.math.random(Game.bounds.w), love.math.random(Game.bounds.h)

  self.maxHealth = 100
  self.health = self.maxHealth
  self.boundsX = function(o) return o.x end
  self.boundsY = function(o) return o.y end
  self.boundsWidth = function(o) return 20 end
  self.boundsHeight = function(o) return 20 end
end

function Cat:update(game, dt)

  local spitballs = game:withinRange(self.x, self.y, self:boundsRadiiSq(), "spitball")
  for _, b in pairs(spitballs) do
    self.health = self.health - b.damage
    b:kill()
  end

  if self.health < 0 then
    self:kill()
  end
end

function Cat:draw(game)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.ellipse("line", self.x, self.y, 20, 20)
  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.rectangle("fill", self.x-self:boundsWidth(), self.y+self:boundsHeight()+10, 2*self:boundsWidth() * (self.health/self.maxHealth), 10)
end

return Cat
