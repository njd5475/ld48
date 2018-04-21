
local Cat = require('gameobject'):derive("cat")

local Game = require('game')

function Cat:_init(x,y)
  require('gameobject')._init(self)
  self.x, self.y = (x or love.math.random(Game.bounds.w)), (y or love.math.random(Game.bounds.h))
  self.w, self.h = 20, 20
  self.maxHealth = 100
  self.height = 20
  self.health = self.maxHealth
  self.boundsX = function(o) return o.x-o.w/2 end
  self.boundsY = function(o) return o.y-o.h/2 end
  self.boundsWidth = function(o) return o.w end
  self.boundsHeight = function(o) return o.h end
  self.boundsCenter = function(o) return o.x, o.y end
  self.feet = function(o) return {{x=o.x, y=o.y+o.height}} end
  self.radii = math.sqrt(self:boundsRadiiSq())
  require('game'):addHud(require('hud.cathud')(self))
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

  love.graphics.setColor(200, 100, 200, 255)

  -- ears
  -- left
  love.graphics.polygon("fill", self.x-self.radii, self.y, self.x-self.radii, self.y-6*self.radii/4, self.x, self.y-self.radii)
  -- right
  love.graphics.polygon("fill", self.x+self.radii, self.y, self.x+self.radii, self.y-6*self.radii/4, self.x, self.y-self.radii)

  -- face
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.ellipse("fill", self.x, self.y, self.radii, self.radii)

  --eyes
  love.graphics.setColor(100, 0, 0, 255)
  local eyeDist = self.radii*0.1
  local eyeSize = self.radii/2
  -- right
  love.graphics.arc("fill", self.x+eyeDist, self.y-eyeDist, eyeSize, 0, -math.pi/6, 20)
  -- left
  love.graphics.arc("fill", self.x-eyeDist, self.y-eyeDist, eyeSize, math.pi, math.pi+math.pi/6, 20)

  love.graphics.setColor(20, 20, 20, 255)
  local mouthSize = self.radii * 0.5
  love.graphics.arc("fill", self.x, self.y+eyeDist, mouthSize, math.pi, 0, 20)
end

return Cat
