
local initState = require('spitball_game')()
local Game = require("engine.game")(initState)
require('hud.playerhud')
require('objects.tester')
require('objects.catgenerator')

require('levelloader')(initState, Game)

love.keyreleased = function(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 's' then
    local screenshot = love.graphics.newScreenshot();
    screenshot:encode('png', os.time() .. '.png');
  end
end
