
local generator = require('gameobject'):derive()

local Cat = require('cat')

function generator:update(game, dt)
  self.timeout = (self.timeout or 1) - dt
  if self.timeout < 0 then
    game:add(Cat())
    self.timeout = 1
  end
end

require('game'):add(generator())
