
local Basic = require('objects.basic')
local Enemy = Basic:derive('Enemy')
local Behaviors = require('engine.behavior')

function Enemy:_init(bounds, sprite, img)
    Basic._init(self, bounds, sprite, img, 'Obelisk')
    print('Adding behavior')
    self:addBehavior('testdelay',
        Behaviors.Sequence(
            Behaviors.Delay(2, function(ctx, dt)
                print('I have been delayed 1')
                return Behaviors.success
            end), 
            Behaviors.Delay(2, function(ctx, dt)
                print('I have been delayed 2')
                return Behaviors.success
            end)
        )
    )
end

return Enemy