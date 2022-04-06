
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
    self.roamSpeed = 25
    self.roamMinDist = 10^2
    self.scanRange = 300^2 
    self:addBehavior('main',
        Behaviors.Sequence(
            Behaviors.Inverter(
                Behaviors.Sequence(
                    Common.scanFor('Player', 'scanRange', 'found', me),
                    Common.moveTo('found', 'speed', 'minDist', me),
                    function(ctx, dt)
                        me.found:damage(me.damage)
                        return Behaviors.success
                    end
                )
            ),
            (function()
                local child = Common.roam({top=50,left=30,bottom=love.graphics.getHeight()-50,right=love.graphics.getWidth()-50}, 'roamSpeed', 'roamMinDist', me)
                return function(ctx, dt)
                    child(ctx, dt)
                    return Behaviors.success
                end
            end)(),
            Behaviors.Sequence(
                Behaviors.Inverter(
                    Common.findClosest('hasPlayer', 'Player', me)
                ),
                Behaviors.Delay(1),
                Common.emit('Muuuaaahhhhh My minions destroyed you! :)'),
                Behaviors.Delay(10),
                function(ctx, dt)
                    if not me.hasPlayer then
                        ctx:changeState('MainMenu')
                    end
                end
            )
        )
    )
end

function Boss:draw(game)
    Basic.draw(self, game)
    SetColor('debugLine')
    love.graphics.circle('line', self:getX(), self:getY(), math.sqrt(self.scanRange))
end

function Boss:update(game, dt)
    Basic.update(self, game, dt)
end

return Boss