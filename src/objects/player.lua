require('common')
local Basic = require('objects.basic')
local Builders = require('objects.builders')
local Pulse = require('effects.pulse')
local Damageable = require('effects.damageable')
local Player = Basic:derive("player")

local CharacterSheet = require('main-sheet')
local COL, ROW = 0, 1

function buildCanvas(img, quad, tw, th)
  local canvas = love.graphics.newCanvas(tw, th)
  canvas:setFilter('linear', 'nearest')
  love.graphics.setCanvas(canvas)
  love.graphics.draw(img, quad, 0, 0, 0, 1, 1)
  local stmode, stalphamode = love.graphics.getBlendMode()
  love.graphics.setBlendMode('add', 'alphamultiply')
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.rectangle("fill", 0, 0, tw, th)
  love.graphics.setCanvas()
  love.graphics.setBlendMode(stmode, stalphamode)
  return canvas
end

function Player:_init(x,y,w,h)
  Basic._init(self, {x=x,y=y,w=w,h=h}, {x=GRID_SIZE*COL,y=GRID_SIZE*ROW,w=GRID_SIZE,h=GRID_SIZE}, CharacterSheet)
  self._speed = 100
  self._immobile = false
  self.health = 100

end

function Player:damage(amount)
  if #self.hearts then
    local h = self.hearts[1]

    h:damage(amount)
    if h:dead() then
      print("Remove a heart :(")
      table.remove(self.hearts, 1)
    end
  end
end

function Player:draw(game, room)
  Basic.draw(self, game)
end

function Player:update(game, dt, room)

  if self.isMoving and not self._immobile then
    self.x, self.y = Vec(self.x, self.y):add(self:getDirection():mult(dt*self:speed())):unwrap()
  end

  self:move(Vec(self.dirX or 0, self.dirY or 0), dt, room)
  self:checkMoveRevert(game, dt, room)

  if not self._immobile then
    --self:updateInput(dt)
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
  self.dirX = -1
end

function Player:stopMovingLeft(game, dt, room)
  self.dirX = 0
end

function Player:moveRight(game, dt, room)
  self.dirX = 1
end

function Player:stopMovingRight(game, dt, room)
  self.dirX = 0
end

function Player:moveUp(game, dt, room)
  self.dirY = -1
end

function Player:stopMovingUp(game, dt, room)
  self.dirY = 0
end

function Player:moveDown(game, dt, room)
  self.dirY = 1
end

function Player:stopMovingDown(game, dt, room)
  self.dirY = 0
end

function Player:move(dir, dt, room)
  local player = self
  player.lastX, player.lastY = player.x, player.y
  player.x, player.y = Vec(player.x, player.y):add(dir:mult(dt):mult(player:speed())):unwrap()
end

function Player:revert()
  self.x, self.y = self.lastX, self.lastY
end

function Player:checkMoveRevert(game, dt, room)
  local isBlocked, byItems = room:isBlocked(self)
  if byItems then
    -- check here for collisions

    if byItems and #byItems > 0 then
      for key, item in ipairs(byItems) do
        if item.canCollide and item:canCollide() then
          item:doCollision(self, game, dt)
        end
      end
    end
  end

  if isBlocked then
    self:revert()
    self.dirX = 0
    self.dirY = 0
    self._immobile = true
  end
end

return Player
