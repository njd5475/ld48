require('engine.common')

local Basic = GameObject:derive("basic")

function Basic:_init(bounds, sprite, img, type)
  GameObject._init(self)
  self.img = img
  self.name = type or 'basic'
  self._type = type
  if self.img then
    self.quad = love.graphics.newQuad(sprite.x, sprite.y, sprite.w, sprite.h, img:getDimensions())
  end
  self.x, self.y = bounds.x, bounds.y
  self.w, self.h = bounds.w, bounds.h
  self.scaleX, self.scaleY = self.w/sprite.w, self.h/sprite.h
  self._canCollide = false
  self.boundsX = function(o) return o.x end
  self.boundsY = function(o) return o.y end
  self.boundsWidth = function(o) return o.w end
  self.boundsHeight = function(o) return o.h end
  self.canCollide = function(o) return o._canCollide end
  self.markCollidable = function(o) o._canCollide = true end
  self.unmarkCollidable = function(o) o._canCollide = false end
  self.behaviors = {}
  self.offBehaviors = {}
end

function Basic:addBehavior(name, behavior)
  self.behaviors[name] = behavior
end

function Basic:updateBehaviors(game, dt)

  for name, behavior in pairs(self.behaviors) do
    if type(behavior) == 'function' then
      behavior(game, dt, self)
    elseif type(behavior) == 'table' then
      local fn = behavior.update or behavior
      fn(game, dt, self)
    end
  end
end

function Basic:hasBehaviors(...)
  local has = true
  for _, name in pairs(...) do
    has = has and not self.behavior[name]
    if not has then
      break -- early return
    end
  end
  return has
end

function Basic:oneBehaviorOf(...)
  for _, name in pairs(...) do
    if self.behavior[name] then
      return true
    end
  end
  return false
end

function Basic:turnOffBehavior(name)
  self.offBehaviors[name] = self.behaviors[name]
  self.behaviors[name] = nil
end

function Basic:turnOnBehavior(name)
  self.behaviors[name] = self.offBehaviors[name]
  self.offBehaviors[name] = nil
end

function Basic:doCollision(hitObj, game, dt)
end

function Basic:update(game, dt)
  GameObject.update(self, game, dt)
  self:updateBehaviors(game, dt)
end

function Basic:draw(game)
  GameObject.draw(self, game)
  if self.img then
    love.graphics.setColor(255, 255, 255, 255)
    local x,y,w,h = self.x, self.y, self:boundsWidth(), self:boundsHeight()
    
    love.graphics.draw(self.img, self.quad, x, y, 0, self.scaleX, self.scaleY)
  end
end

function Basic:derive(type)
  local newClass = Class(self)
  if type then
    newClass._type = type
  end
  return newClass
end

return Basic
