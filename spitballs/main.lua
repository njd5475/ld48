
local Game = require("game")
require('spitballtest')

love.keyreleased = function(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 's' then
    local screenshot = love.graphics.newScreenshot();
    screenshot:encode('png', os.time() .. '.png');
  end
end
