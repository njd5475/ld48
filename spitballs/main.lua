
local Game = require("game")
require('playerhud')
require('spitballtest')
require('catgenerator')

love.keyreleased = function(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 's' then
    local screenshot = love.graphics.newScreenshot();
    screenshot:encode('png', os.time() .. '.png');
  end
end
