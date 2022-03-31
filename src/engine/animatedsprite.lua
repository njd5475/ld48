require('engine.gameobject')

local Frame = require('engine.frame')
local Animation = require('engine.animation')
local AnimatedSprite = GameObject:derive("AnimatedSprite")

function AnimatedSprite:_init(defaultAnimation)
  assert(defaultAnimation, "Must have an image for the sprite")
  GameObject._init(self)
  self.image = image
  self.running = true
  self.loop = false
  self._completed = false
  self.scaleX, self.scaleY = 1, 1
  self.animations = { default = defaultAnimation }
  self.current = 'default'
  assert(self:getCurrent())
end

function AnimatedSprite:update(dt)
  if self.running then
    local done = self:getCurrent():update(dt)

    -- looping logic
    if done and self.looping then
      self:getCurrent():reset()
    end

    -- not looping
    if done and not self.looping then
      self._completed = true
      self:stop()
    end
  end
end

function AnimatedSprite:addAnimation(name, animation)
  self.animations[name] = animation
end

function AnimatedSprite:getCurrent()
  return self.animations[self.current]
end

function AnimatedSprite:makeLoop()
  self.loop = true
end

function AnimatedSprite:stopLooping()
  self.loop = false
end

function AnimatedSprite:draw()
  self:getCurrent():draw()
end

function AnimatedSprite:flipX()
  self.scaleX = -self.scaleX
end

function AnimatedSprite:flipY()
  self.scaleY = -self.scaleY
end


function AnimatedSprite:getQuadIndex()
  if self.counter == self.duration then
    return 1
  end
  return math.ceil(((self.duration - self.counter) / self.duration) * #self.quads)
end

function AnimatedSprite:getAnimation(name)
  return self.animations[name]
end

function AnimatedSprite:start(name)
  self.running = true
  self._completed = false
  self:getAnimation(name):reset()
end

function AnimatedSprite:stop()
  self.running = true
  self:getAnimation(self.current):stop()
end

function AnimatedSprite:toggle()
  self.running = not self.running
end

function AnimatedSprite:loopable()
  self.loop = not self.loop
end

function AnimatedSprite:completed()
  return self._completed
end

AnimatedSprite.buildQuads = function(quads, image, indices, tileinfo)
  quads = quads or {}
  
  local imgW, imgH = image:getDimensions()
  local tW, tH, sX, sY, offX, offY = tileinfo.w, tileinfo.h, tileinfo.startX, tileinfo.startY, tileinfo.off.x, tileinfo.off.y
  local cols, rows = (imgW - sX) / (tW + offX), (imgH - sY) / (tH + offY)
  cols, rows = math.ceil(cols), math.ceil(rows)
  
  for _, i in pairs(indices) do 
    local y = math.floor((i-1) / cols)
    local x = (i-1) - (y * cols)
    x,y = x * (tW + offX), y * (tH + offY)
    local q = love.graphics.newQuad(x, y, tW, tH, imgW, imgH)
    table.insert(quads, q)
  end
  
  return quads
end

-- frames - array of { i=<index>, d=<duration> } i can be index or i
--          d can be duration or d
AnimatedSprite.buildAnimation = function(image, frames, tileinfo)
  assert(image, "Must have an image to build animation from???")
  assert(frames, "Must have frames to use from the image for animation???")
  assert(tileinfo, "Must have tileinfo to find frames in the image???")
  local indices = {}
  for i, f in ipairs(frames) do
    table.insert(indices, f.i or f.index)
  end

  local frameObjs = {}
  local quads = AnimatedSprite.buildQuads({}, image, indices, tileinfo)
  for i, q in ipairs(quads) do
    local frame = Frame(image, q, frames[i].d or frames[i].duration) --use rotation, scale, and offset, defaults
    table.insert(frameObjs, frame)
  end

  return Animation(frameObjs)
end

return AnimatedSprite
