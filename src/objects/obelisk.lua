
local Obelisk = Basic:derive('Obelisk')


function Obelisk:_init(x, y, sprite, img)
    Basic._init(self, {x=x, y=y, w=32, h=64}, sprite, img, 'Obelisk')
end

function Obelisk:draw(game)
    Basic.draw(game)
    self.others = {}
end

function Obelisk:summons(demon)
    if demon.isdemon then
        self.demon = demon
    end
end

function Obelisk:link(other)
    assert(other, 'Need other obelisk not nil')
    table.insert(self.others, other)
end

function Obelisk:theOthers()
    return self.others
end

function Obelisk:update(game, dt)
end

return Obelisk