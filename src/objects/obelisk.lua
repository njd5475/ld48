
local Basic = require('objects.basic')
local Obelisk = Basic:derive('Obelisk')


function Obelisk:_init(bounds, sprite, img)
    Basic._init(self, bounds, sprite, img, 'Obelisk')
    self.maxCharge = 1000
    self.charge = 0
    
    self.getMaxCharge = function(o) return o.maxCharge end
    self.getCharge = function(o) return o.charge end
    self.isCharged = function(o) return o.charge >= o.maxCharge end
end

function Obelisk:update(game, dt)
    Basic.update(self, game, dt)
end

function Obelisk:draw(game)
    Basic.draw(self, game)
    self.others = {}
end

function Obelisk:transfer(charge)
    self.charge = math.min(self.maxCharge, self.charge + charge)
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


return Obelisk