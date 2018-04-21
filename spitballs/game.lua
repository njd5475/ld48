
local Game = require("class")()

Game._init = function(g)
  g.inc = 0
end

Game.name = function(g)
  g.inc = (g.inc or 0) + 1
  return "" .. g.inc
end

return Game()
