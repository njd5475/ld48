require('common')
local Basic = require('objects.basic')
local Player = Basic:derive("player")

local CharacterSheet = require('ld48sheet')

function Player:_init(x,y,w,h)
  Basic._init(self, {x=x,y=y,w=w,h=h}, {x=16*5,y=16*1,w=16,h=16}, CharacterSheet)
  self._speed = 100
  self._immobile = false
end

function Player:draw(game, room)
  Basic.draw(self, game)
end

function Player:update(game, dt)

  if self.isMoving and not self._immobile then
    self.x, self.y = Vec(self.x, self.y):add(self:getDirection():mult(dt*self:speed())):unwrap()
  end

  if not self._immobile then
    self:updateInput(dt)
  end
end

function Player:immobile()
  self._immobile = true
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

function Player:moveLeft(game, dt, room)
  self:move(self, Vec(-1, 0), dt, room)
  self:checkMoveRevert(room, game)
end

function Player:moveRight(game, dt, room)
  self:move(self, Vec(1, 0), dt, room)
  self:checkMoveRevert(room, game)
end

function Player:moveUp(game, dt, room)
  self:move(self, Vec(0, -1), dt, room)
  self:checkMoveRevert(room, game)
end

function Player:moveDown(game, dt, room)
  self:move(self, Vec(0, 1), dt, room)
  self:checkMoveRevert(room, game)
end

function Player:move(player, dir, dt, room)
  player.lastX, player.lastY = player.x, player.y
  player.x, player.y = Vec(player.x, player.y):add(dir:mult(dt):mult(player:speed())):unwrap()
end

function Player:revert()
  self.x, self.y = self.lastX, self.lastY
end

function Player:checkMoveRevert(room, game)
  local isBlocked, byItems = room:isBlocked(self)
  if byItems then
    -- check here for collisions

    if byItems and #byItems > 0 then
      for key, item in ipairs(byItems) do
        if item.canCollide and item:canCollide() then
          item:doCollision(self, game)
        end
      end
    end
  end

  if isBlocked then
    self:revert()
  end
end

return Player
