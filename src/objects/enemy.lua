
local Basic = require('objects.basic')
local Enemy = Basic:derive('Enemy')
local Behaviors = require('engine.behavior')
local Common = require('behaviors.common')

function Enemy:_init(bounds, sprite, img)
    Basic._init(self, bounds, sprite, img, 'Enemy')
    print('Adding behavior')
    local me = self
    self.damage = 10
    self.speed = 40
    self.minDist = 10^2
    self.minAttackRange = 100^2
    self.followRange = 150^2
    self.health = 400

    self:addBehavior('testdelay',
        Behaviors.Sequence(
            Behaviors.Inverter(
                Behaviors.Sequence(
                    Common.scanFor('Player', 'followRange', 'foundPlayer', me),
                    Common.moveTo('foundPlayer', 'speed', 'minAttackRange', me),
                    Common.emit('An Enemy deals you ' .. self.damage .. ' damage'),
                    Common.attack('foundPlayer', 'damage', me)
                )
            ),
            Behaviors.Sequence(
                Common.findClosest('found', 'Obelisk', me),
                Common.moveTo('found', 'speed', 'minDist', me),
                Behaviors.Delay(1),
                function(ctx, dt)
                    local o = me.found
                    if not o:isCharged() then
                        o:transfer(10)
                        return Behaviors.success
                    end
                    return Behaviors.success
                end
            )
        )
    )
end

function Enemy:hurt(amount)
    self.health = math.max(0, self.health - amount)
    if self.health <= 0 then
        self:kill()
    end
end

function Enemy:draw(game)
    Basic.draw(self, game)
    SetColor('debugOrigins')
    local cx, cy = self:boundsCenter()
    love.graphics.ellipse('fill', cx, cy, 5, 5)
    love.graphics.ellipse('line', cx, cy, math.sqrt(self.followRange), math.sqrt(self.followRange))
    love.graphics.ellipse('line', cx, cy, math.sqrt(self.minAttackRange), math.sqrt(self.minAttackRange))
end

return Enemy