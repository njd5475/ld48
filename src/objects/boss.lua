
local Basic = require('objects.basic')
local Boss = Basic:derive('Boss')

function Boss:_init(x, y, sprite, img)
    Basic._init(self, {x=x, y=y, w=64, h=128}, sprite, img, 'Boss')
end

return Boss