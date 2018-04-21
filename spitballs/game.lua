
local Game = require("class")()

require('utils')

function Game:_init()
  print("Initialize the game")
  self.objects = {}
  local me = self
  love.draw = function() me:draw() end
  love.update = function(dt) me:update(dt) end
  self.bounds = {
    x = 0,
    y = 0,
    w = love.graphics:getWidth(),
    h = love.graphics:getHeight()
  }
  self.hud = {}
  self.player = require('player')()
  self:add(self.player)
end

function Game:draw()
  for _, b in pairs(self.objects) do
    b:draw(self)
  end

  for _, b in pairs(self.hud) do
    b:draw(self)
  end
end

function Game:update(dt)
  for _, b in pairs(self.objects) do
    if not b:dead() then
      b:update(self, dt)
    else
      self.objects[b:id()] = nil
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

function Game:add(o)
  if o.dead and o.id and not o:dead() then
    self.objects[o:id()] = o
  else
    print("Err: Game only accepts non-dead game objects")
  end
end

function Game:addHud(o)
  if o.dead and o.id and not o:dead() then
    self.hud[o:id()] = o
  else
    print("Err: Hud only accepts non-dead game objets")
  end
end

function Game:outside(go)
  return not collides(self.bounds, go:bounds())
end

return Game()
