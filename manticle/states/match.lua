require('common')

local Match = State:derive()

function Match:_init(players)
  State._init(self, "Match")
  self.players = players
end

function Match:init(game)
  for _, p in pairs(self.players) do
    p.x = math.random(0, game.bounds.w)
    p.y = math.random(0, game.bounds.h)
    self:add(p)
  end
end

function Match:draw(game)
  State.draw(self, game)
  love.graphics.setFont(LogoMidFont)
  love.graphics.print("Players Alive: " .. #self.players, 0, 5)
end

function Match:update(game, dt)
  State.update(self, game, dt)
end

return Match
