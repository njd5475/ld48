
local PlayerHud = require('gameobject'):derive("playerhud")

function PlayerHud:_init(player)
  require('gameobject')._init(self)
  self.player = player
end

-- TODO pretty this display up
function PlayerHud:draw(game)
  love.graphics.print("Machines: " .. #self.player.machines, 0, 30)
end

require('game'):addHud(PlayerHud(require('game').player))
