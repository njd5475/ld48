require('engine.common')
local tester = GameObject:derive()

local Spitball = require('spitball')

function tester:_init()
  GameObject._init(self)
end

function tester:update(game, dt)
  self.timeout = (self.timeout or 0.12) - dt
  if love.keyboard.isDown("space") and self.timeout <= 0 then
    local ball = Spitball()
    ball:spit()
    game:add(ball)
    self.timeout = 0.1
  end
end

require('game'):add(tester())
