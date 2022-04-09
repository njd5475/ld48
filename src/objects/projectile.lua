
local Basic = require('objects.basic')

local Builders = require('objects.builders')
local Projectile = Basic:derive('Projectile')

function Projectile:_init(bounds, sprite, img, objType)
    Basic._init(self, bounds, sprite, img, objType)
    self.direction = Vec.Zero:copy()
    self.speed = 400
    self.hitRange = 30^2
    self.damage = 20
end

function Projectile:draw(game)
    Basic.draw(self, game)
end

function Projectile:update(game, dt)
    Basic.update(self, game, dt)

    local dx, dy = self.direction:mult(self.speed*dt):unwrap()
    self.x, self.y = self.x + dx, self.y + dy
    local cX, cY = self:boundsCenter()

    -- find all enemies to damage
    local results = game:withinRange(cX, cY, self.hitRange, 'Enemy')
    if #results > 0 then
        results[1]:hurt(self.damage)
        self:kill()
    end

    local w, h = self:boundsWidth()/2, self:boundsHeight()/2
    if cX < -w or cY < -h or cX > love.graphics:getWidth()+w or cY > love.graphics.getHeight()+h then
        -- kill if off screen or out of view
        print('Killed')
        self:kill()
    end
end

Projectile.generate = function(game, direction, x, y, w, h)
    local projectile = Builders.buildProjectile(x, y, w, h, true, Projectile)
    projectile.direction = direction
    game:add(projectile)
    return projectile
end

return Projectile