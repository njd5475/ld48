
local Basic = require('objects.basic')
local Enemy = Basic:derive('Enemy')
local Behaviors = require('engine.behavior')

function Enemy:_init(bounds, sprite, img)
    Basic._init(self, bounds, sprite, img, 'Obelisk')
    print('Adding behavior')
    self:addBehavior('testdelay', Behaviors.Delay(2, function(ctx, dt)
        print('I have been delayed')
        return Behaviors.running
    end))
end

return Enemy