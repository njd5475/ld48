
local Spitball = require('class')(require('gameobject'))

local SpitAudio = {}
SpitAudio[0] = love.audio.newSource("spit-01.wav", "static")
SpitAudio[1] = love.audio.newSource("spit-02.wav", "static")
SpitAudio[2] = love.audio.newSource("spit-03.wav", "static")

function Spitball:_init()
  require('gameobject'):_init(self)
  self.x, self.y = love.graphics:getWidth()/2, love.graphics:getHeight()/2
  self.dir = {
    x = 1,
    y = 0
  }
  self.speed = 1000
end

function Spitball:draw(game)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.ellipse("fill", self.x, self.y, 5, 5)
end

function Spitball:update(game, dt)
  self.x = self.x + self.dir.x * dt * self.speed
  self.y = self.y + self.dir.y * dt * self.speed
end

function Spitball:spit()
  love.audio.play(SpitAudio[love.math.random(#SpitAudio)]:clone())
end

return Spitball
