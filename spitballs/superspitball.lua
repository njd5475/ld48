
local Spitball = require('spitball')

local SuperSpitball = require('class')(Spitball)

function SuperSpitball:_init()
  print("This is my main")
  self:spit()
end

return SuperSpitball
