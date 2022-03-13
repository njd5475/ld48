require('common')
local Basic = require('objects.basic')
local Builders = require('objects.builders')
local Player = Basic:derive("player")

local CharacterSheet = require('ld48sheet')

function Player:_init(x,y,w,h)
  Basic._init(self, {x=x,y=y,w=w,h=h}, {x=16*3,y=16*1,w=16,h=16}, CharacterSheet)
  self._speed = 100
  self._immobile = false
  self.health = 4
  self.hearts = {}
  self.tweeners = {}
  for i=1,self.health do
    local heart = Builders.buildHeart((16+i)*30,16, 32, 32)
    table.insert(self.hearts, heart)
    self.tweeners[heart] = {
      enabled=true,
      initialized=false,
      heart=heart,
      init=function(self)
        if not self.initialized then
          self.oldC = {r=1, g=1, b=1, a=0}
          self.color = {r=0, g=0, b=0, a=0}
          self.tweener = Tween.new(2, self.color, {r=1, g=1, b=1, a=0}, Tween.easing.outSine)
          self.initialized = true
        end
      end,
      before=function(self, game, g)
        self:init()
        self.oldC.r, self.oldC.g, self.oldC.b, self.oldC.a = g:getColor()
        --g.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        local h = self.heart
        local b = h:bounds()
        local c = self.color
        self.blendmode = g.getBlendMode()
        -- g.setBlendMode('add', 'premultiplied')
        -- g.setColor(1,1,1,1)
      end,
      after=function(self, game, g)
        self:init()
        local h = self.heart
        local b = h:bounds()
        local c = self.color
        -- self.blendmode = g:getBlendMode()
        -- g.setBlendMode("multiply", "premultiplied")
        -- self.oldC.r, self.oldC.g, self.oldC.b, self.oldC.a = g:getColor()
        -- g.setColor(c.r, c.g, c.b, c.a)
        -- g.rectangle('fill', b.x, b.y, b.w, b.h)
        -- g.setBackgroundColor(self.oldC.r, self.oldC.g, self.oldC.b, self.oldC.a)
        g.setBlendMode(self.blendmode or 'alpha')
      end,
      update=function(self, game, dt)
        self:init()
        self.tweener:update(dt)
      end
    }
  end
end

function Player:draw(game, room)
  Basic.draw(self, game)
  for i, h in ipairs(self.hearts) do
    self:drawTweenerBefore(h, game, love.graphics)
    h:draw(game, room)
    self:drawTweenerAfter(h, game, love.graphics)
  end
end

function Player:drawTweenerBefore(heart, game, g)
  local t = self.tweeners[heart]
  if t.enabled then
    t:before(game, g)
  end
end

function Player:drawTweenerAfter(heart, game, g)
  local t = self.tweeners[heart]
  if t.enabled then
    t:after(game, g)
  end
end

function Player:enableTweener(heart, game, g)
  local t = self.tweeners[heart]
  t.enabled = true
end

function Player:disableTweener(heart, game, g)
  local t = self.tweeners[heart]
  t.enabled = false
end

function Player:update(game, dt, room)

  if self.isMoving and not self._immobile then
    self.x, self.y = Vec(self.x, self.y):add(self:getDirection():mult(dt*self:speed())):unwrap()
  end

  self:move(Vec(self.dirX or 0, self.dirY or 0), dt, room)
  self:checkMoveRevert(room, game)

  if not self._immobile then
    --self:updateInput(dt)
  end

  for i,h in ipairs(self.hearts) do
    local t = self.tweeners[h]
    if t.enabled then
      t:update(game, dt)
    end
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
    self.dirX = 0
    self.dirY = 0
    self._immobile = true
  end
end

return Player
