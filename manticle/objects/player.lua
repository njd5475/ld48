require('engine.common')
local Basic = require('objects.basic')
local Player = Basic:derive("player")

local img = love.graphics.newImage("images/human1.png")

img:setFilter("nearest", "nearest")

function Player:_init(x,y,w,h)
  Basic._init(self, {x=x,y=y,w=w,h=h}, {x=0,y=0,w=16,h=32}, img)
  self._speed = 100

end

function Player:update(game, dt)

  if self.isMoving then
    self.x, self.y = Vec(self.x, self.y):add(self:getDirection():mult(dt*self:speed())):unwrap()
  end

  self:updateInput(dt)
end

function Player:setInput(mode, joy)
  if mode == "keyboard" then
    self.getDirection = function(o) return self._dir end
    self.updateInput = function(o, dt)
      if love.keyboard.isDown('a') then
        self._dir = Vec(-1, 0)
        self.isMoving = true
      elseif love.keyboard.isDown('d') then
        self._dir = Vec(1, 0)
        self.isMoving = true
      else
        self.isMoving = false
      end
    end
  elseif mode == "mouse" then
    self.getDirection = function(o) return self._dir end
    self.updateInput = function(o, dt)
      if love.mouse.isDown(1) then
        local dx = love.mouse.getX() - self.x
        if not (dx == 0) then
          self._dir = Vec(dx/math.abs(dx), 0)
          self.isMoving = true
        end
      else
        self.isMoving = false
      end
    end
  elseif mode == "joystick" then
    self.getDirection = function(o) return self._dir end
    self.updateInput = function(o, dt)
      local dx, dy = joy:getGamepadAxis("leftx"), joy:getGamepadAxis("lefty")
      if not (dx == 0) then
        self._dir = Vec(dx, 0)
        self.isMoving = true
      else
        self.isMoving = false
      end
    end
  end
end

function Player:speed()
  return self._speed
end

function Player:moveLeft(game, dt)
  self:move(self, Vec(-1, 0), dt)
  if self.scaleX < 0 then
    self.scaleX = -self.scaleX
  end
end

function Player:moveRight(game, dt)
  self:move(self, Vec(1, 0), dt)
  if self.scaleX > 0 then
    self.scaleX = -1 * self.scaleX
  end
end

function Player:move(player, dir, dt)
  player.x, player.y = Vec(player.x, player.y):add(dir:mult(dt):mult(player:speed())):unwrap()
end

return Player
