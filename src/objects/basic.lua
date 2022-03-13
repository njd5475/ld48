require('engine.common')

local Basic = GameObject:derive("basic")

function Basic:_init(bounds, sprite, img, type)
  GameObject._init(self)
  self.img = img
  self.name = type or 'basic'
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
end

function Basic:doCollision(hitObj, game)
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
