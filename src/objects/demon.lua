
local Demon = Basic:derive('Demon')

function Demon:_init(x, y, sprite, img)
    Basic._init(self, {x=x, y=y, w=64, h=128}, sprite, img, 'Demon')
end

return Demon