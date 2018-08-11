require('engine.common')
local LevelLoader = Class()

function LevelLoader:_init(state, game)
  local Platform = require('platform')
  local plat = Platform(0, game.bounds.h-30, game.bounds.w, 50)
  state:add(plat)

  local Litterbox = require('litterbox')
  state:add(Litterbox(0, plat.y-50))

  local MilkAndCookies = require('milkandcookies')
  state:add(MilkAndCookies(plat.x+plat.w-75, plat.y-50))
end

return LevelLoader
