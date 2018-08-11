
local generator = require('engine.gameobject'):derive("catgenerator")

local Cat = require('cat')

function generator:update(game, dt)

end

require('game'):add(generator())
