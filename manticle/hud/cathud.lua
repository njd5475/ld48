
local CatHud = require('gameobject'):derive('CatHud')

function CatHud:_init(cat)
  require('gameobject')._init(self)
  self.cat = cat
end

function CatHud:draw(game)
  local cat = self.cat
  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.rectangle("fill", cat.x-cat:boundsWidth(), cat.y+cat:boundsHeight()+10, 2*cat:boundsWidth() * (cat.health/cat.maxHealth), 10)
end

function CatHud:dead()
  return self.cat:dead()
end

return CatHud
