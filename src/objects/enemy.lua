
local Basic = require('objects.basic')
local Enemy = Basic:derive('Enemy')
local Behaviors = require('engine.behavior')
local Common = require('behaviors.common')

function Enemy:_init(bounds, sprite, img)
    Basic._init(self, bounds, sprite, img, 'Obelisk')
    print('Adding behavior')
    local me = self
    self.damage = 10
    self.followRange = 30
    self.speed = 40
    self.minDist = 20^2

    self:addBehavior('testdelay',
        Behaviors.Sequence(
            Behaviors.Sequence(
                Common.findClosest(me, 'found', 'Obelisk'),
                Common.moveTo(me, 'found', 'speed', 'minDist'),
                function(ctx, dt)
                    local o = me.found
                    if not o:isCharged() then
                        o:transfer(10)
                        return Behaviors.running
                    end
                    return Behaviors.success
                end
            ),
            function(ctx, dt)
                local results = ctx:withinRange(me:getX(), me:getY(), me.followRange, 'Player')
                if #results > 0 then
                    
                    Emit('Enemy ' .. self:id() .. ' deals you ' .. self.damage .. ' damage')
                    results[1]:damage(self.damage)
                else
                    --print('Could not find player')
                end
                return Behaviors.success
            end,
            Behaviors.Delay(2, function(ctx, dt)
                return Behaviors.success
            end)
        )
    )
end

function Enemy:draw(game)
    Basic.draw(self, game)
    SetColor('debugOrigins')
    love.graphics.ellipse('fill', self:getX(), self:getY(), 5, 5)
    love.graphics.ellipse('line', self:getX(), self:getY(), self.followRange, self.followRange)
end

return Enemy