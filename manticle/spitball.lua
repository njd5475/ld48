
local GameObject = require('gameobject')
local Spitball = GameObject:derive("spitball")

local SpitAudio = {}
SpitAudio[0] = love.audio.newSource("music/spit-01.wav", "static")
SpitAudio[1] = love.audio.newSource("music/spit-02.wav", "static")
SpitAudio[2] = love.audio.newSource("music/spit-03.wav", "static")

function Spitball:_init(x, y, dirX, dirY)
  GameObject._init(self)
  self.x, self.y = (x or love.graphics:getWidth()/2), (y or love.graphics:getHeight()/2)
  self.dir = {
    x = dirX or 1,
    y = dirY or 0
  }
  self.damage = 5
  self.speed = 200
  self.boundsX = function(o) return o.x end
  self.boundsY = function(o) return o.y end
  self.boundsWidth = function(o) return 5 end
  self.boundsHeight = function(o) return 5 end
  self:spit()
  self:stop()
end

function Spitball:draw(game)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.ellipse("fill", self.x, self.y, 5, 5)
end

function Spitball:update(game, dt)
  self.x = self.x + self.dir.x * dt * self.speed
  self.y = self.y + self.dir.y * dt * self.speed

  if game:outside(self) then
    self:kill()
  end
end

function Spitball:spit()
  love.audio.play(SpitAudio[love.math.random(#SpitAudio)]:clone())
end

return Spitball
