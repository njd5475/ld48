
local machine = require('gameobject'):derive("spitballmachine")

function machine:_init()
  require('gameobject')._init(self)
end

function machine:draw(game)
  love.graphics.ellipse("fill", self.x, self.y, 20, 20)
end

function machine:drawIcon(game)

end

function machine:place(x,y,game)
  self.x, self.y = x, y
  game:add(self)
end

return machine
