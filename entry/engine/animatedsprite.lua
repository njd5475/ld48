require('engine.gameobject')

local AnimatedSprite = GameObject:derive("AnimatedSprite")

function AnimatedSprite:_init(image, tileinfo, indices, duration)
  assert(image, "Must have an image for the sprite")
  assert(tileinfo, "Must have information about the tiles in the sprite image")
  assert(indices, "Animations need to be a series of frames by index")
  assert(duration, "Animations have some kind of total time frame")
  GameObject._init(self)
  self.image = image
  self.tileinfo = tileinfo
  self.imgW, self.imgH = self.image:getDimensions()
  self.tileCols, self.tileRows = (self.imgW-tileinfo.startX)/(tileinfo.w+tileinfo.off.x), (self.imgH-tileinfo.startY)/(tileinfo.h+tileinfo.off.y)
  self.tileCols, self.tileRows = math.ceil(self.tileCols), math.ceil(self.tileRows)
  self.indices = indices
  self.duration = duration
  self.counter = self.duration
  self.running = true
  self.loop = false
  self._completed = false
  self.scaleX, self.scaleY = 1, 1
  self:buildQuads()
end

function AnimatedSprite:makeLoop()
  self.loop = true
end

function AnimatedSprite:stopLooping()
  self.loop = false
end

function AnimatedSprite:draw(game)
  love.graphics.draw(self.image, self.quads[self:getQuadIndex()], 0, 0, 0, self.scaleX, self.scaleY)
end

function AnimatedSprite:flipX()
  self.scaleX = -self.scaleX
end

function AnimatedSprite:flipY()
  self.scaleY = -self.scaleY
end

function AnimatedSprite:update(game, dt)
  if self.running then
    self.counter = self.counter - dt

    if self.counter <= 0 then
      if self.loop then
        self:start()
      else
        self._completed = true
        self:stop()
      end
    end
  end
end

function AnimatedSprite:getQuadIndex()
  if self.counter == self.duration then
    return 1
  end
  return math.ceil(((self.duration - self.counter) / self.duration) * #self.quads)
end

function AnimatedSprite:start()
  self.counter = self.duration
  self.running = true
  self._completed = false
end

function AnimatedSprite:stop()
  self.counter = 0
  self.running = true
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

function AnimatedSprite:buildQuads()
  self.quads = {}
  for _, i in pairs(self.indices) do
    local y = math.floor((i-1) / self.tileCols)
    local x = (i-1) - (y*self.tileCols)
    x,y = x*(self.tileinfo.w+self.tileinfo.off.x), y*(self.tileinfo.h+self.tileinfo.off.y)
    local q = love.graphics.newQuad(x, y, self.tileinfo.w, self.tileinfo.h, self.imgW, self.imgH)
    table.insert(self.quads, q)
  end
end

return AnimatedSprite
