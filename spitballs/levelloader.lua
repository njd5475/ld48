
local LevelLoader = require('class')()

function LevelLoader:_init(level)
  local game = require('game')
  local Platform = require('platform')
  local plat = Platform(0, game.bounds.h-30, game.bounds.w, 20)
  game:add(plat)

  local Litterbox = require('litterbox')
  game:add(Litterbox(0, plat.y-50))

  local MilkAndCookies = require('milkandcookies')
  game:add(MilkAndCookies(plat.x+plat.w-75, plat.y-50))
end

return LevelLoader
