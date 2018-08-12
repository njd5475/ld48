require('engine.common')

local Selection = GameObject:derive("Selection")
local font = love.graphics.newFont("fonts/press-start-2p/PressStart2P-Regular.ttf", 12)

function Selection:_init(x,y,w,h)
  GameObject._init(self)
  self.x, self.y, self.w, self.h = x, y, w, h
  self.msg = "Press any key to select"
  self.mode = "selectable"
end

function Selection:draw(game)
  love.graphics.setFont(font)
  love.graphics.setColor(33, 33, 33, 255)
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
  if self:selectable() then
    local msg = self.msg
    love.graphics.setColor(240, 240, 240, 255)
    love.graphics.print(msg, self.x + self.w/2 - font:getWidth(msg)/2, self.y + self.h/2)
  end

  if self:choosable() then
    for _,
  end
end

function Selection:selectable()
  return self.mode == "selectable"
end

function Selection:choosable()
  return self.mode == "choosable"
end

return Selection
