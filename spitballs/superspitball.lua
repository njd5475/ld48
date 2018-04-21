
local SuperSpitball = require('spitball'):derive("SuperSpitball")

function SuperSpitball:_init()
  require('spitball')._init(self)
  self:spit()
end

return SuperSpitball
