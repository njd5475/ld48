
require('engine.common')

local GameState = Class(State)
local PlayerHud = require('hud.playerhud')
local Generator = require('catgenerator')

function GameState:_init()
  State._init(self, "SpitballMain")
  self.gravity = 319 --639 --200 --639
  self.hud = {}
  self.player = require('player')()
  self:add(self.player)
  self:add(PlayerHud(self.player))

  self.gameOver = false
end

function GameState:init(game)
  self:add(Generator(game))
end

function GameState:draw(game)
  State.draw(self, game)
  love.graphics.setColor(150, 150, 245, 255)
  love.graphics.rectangle("fill", 0, 0, love.graphics:getWidth(), love.graphics:getHeight())
  for _, b in pairs(self.objects) do
    b:draw(self)
  end

  for _, b in pairs(self.hud) do
    b:draw(self)
  end

  if self.gameOver then
    local f = love.graphics.getFont()
    love.graphics.print("Game Over", love.graphics:getWidth()/2-f:getWidth("Game Over")/2 , love.graphics.getHeight()/2-f:getHeight())
  end
end

function GameState:update(game, dt)
  State.update(self, game, dt)
  if not self.gameOver then
    for _, b in pairs(self.objects) do
      if not b:dead() then
        b:update(game, dt)
        self:fallOrStop(game, b, dt)
      else
        self.objects[b:id()] = nil
        self.types[b:type()][b:id()] = nil
      end
    end

    for _, b in pairs(self.hud) do
      if not b:dead() then
        b:update(self, dt)
      else
        self.hud[b:id()] = nil
      end
    end
  end
end

function GameState:fallOrStop(game, o, dt)
  if o.y then
    if o:moveable() then

      local lastY = o.y
      o.y = o.y + self.gravity * dt
      if o.y > game.bounds.x + game.bounds.h and game:outside(o) then
        print("Killing the " .. o:type() .. " because it dropped below the world")
        o:kill()
      else
        local bounds = o:bounds()
        local feet = o:feet()
        for _, f in pairs(feet) do
          local results = self:withinRange(f.x, f.y, o:boundsRadiiSq(), "platform")
          for _, p in pairs(results) do
            if inside(p:bounds(), f.x, f.y) then
              o.y = lastY
              o:adjustToPlatform(p)
            end
          end
        end
      end
    end
  end
end

function GameState:addHud(o)
  if o.dead and o.id and not o:dead() then
    self.hud[o:id()] = o
  else
    print("Err: Hud only accepts non-dead game objets")
  end
end

function GameState:catsGotMilk()
  print("Game Over")
  self.gameOver = true
end

return GameState
