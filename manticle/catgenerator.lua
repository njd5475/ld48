
local generator = require('gameobject'):derive("catgenerator")

local Cat = require('cat')

function generator:update(game, dt)

end

require('game'):add(generator())
