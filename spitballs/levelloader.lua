
local LevelLoader = require('class')()

function LevelLoader:_init(level)
  local game = require('game')
  local Platform = require('platform')
  game:add(Platform(0, game.bounds.h-30, game.bounds.w, 20))
end

return LevelLoader
