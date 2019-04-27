require('common')
local LevelLoader = Class()

function LevelLoader:_init(state, game)
  local plat = Platform(0, game.bounds.h-30, game.bounds.w, 50)
  state:add(plat)
  state:add(Litterbox(0, plat.y-50))
  state:add(MilkAndCookies(plat.x+plat.w-75, plat.y-50))
end

return LevelLoader
