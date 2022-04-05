
local Basic = require('objects.basic')
local Boss = Basic:derive('Boss')

local Behaviors = require('engine.behavior')
local Common = require('behaviors.common')

function Boss:_init(bounds, sprite, img)
    Basic._init(self, bounds, sprite, img, 'Boss')

    local me = self
    self.minDist = 40^2
    self.speed = 100
    self.damage = 99
    self:addBehavior('testdelay',
        Behaviors.Sequence(
            Common.findClosest(me, 'found', 'Player'),
            Common.moveTo(me, 'found', 'speed', 'minDist'),
            function(ctx, dt)
                me.found:damage(me.damage)
                return Behaviors.success
            end
        )
    )
end

return Boss