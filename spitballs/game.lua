
local Game = require("class")()
local Spitball = require('spitball')

function Game:_init()
  self.objects = {}
  local me = self
  love.draw = function() me:draw() end
  love.update = function(dt) me:update(dt) end
end

function Game:add(o)
  if o.dead and o.id and not o:dead() then
    self.objects[o:id()] = o
  end
end

function Game:draw()
  for _, b in pairs(self.objects) do
    b:draw(self)
  end
end

function Game:update(dt)
  for _, b in pairs(self.objects) do
    b:update(self, dt)
    if b:dead() then
      self.objects[b:id()] = nil
    end
  end

  self.timeout = (self.timeout or 0.12) - dt
  if love.keyboard.isDown("space") and self.timeout <= 0 then
    local ball = Spitball()
    ball:spit()
    self:add(ball)
    self.timeout = 0.1
  end
end

return Game()
