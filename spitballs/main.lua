
local Game = require("game")

local Spitball = require('spitball')

local objects = {}

love.draw = function()
  love.graphics.print("I'm the Ultimate", love.graphics:getWidth()/2, love.graphics:getHeight()-10)
  for _, b in pairs(objects) do
    b:draw(Game)
  end
end

function love.update(dt)
  for _, b in pairs(objects) do
    b:update(Game, dt)
    if b:dead() then
      objects[b:id()] = nil
    end
  end

  Game.timeout = (Game.timeout or 0.12) - dt
  if love.keyboard.isDown("space") and Game.timeout <= 0 then
    local ball = Spitball()
    ball:spit()
    objects[ball:id()] = ball
    Game.timeout = 0.1
  end
end

love.keyreleased = function(key)
  if key == 'escape' then
    love.event.quit()
  end
end
