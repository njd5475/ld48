local GameObject = require('engine.gameobject')

local Entity = GameObject:derive('Entity')

function Entity:_init(animations, x, y, scaleX, scaleY)
    GameObject._init(self)
    self.animations = animations
    self.scaleX, self.scaleY = scaleX or 1, scaleY or 1
    self.x, self.y = x, y
end

function Entity:draw(game)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.scale(self.scaleX, self.scaleY)
    self.animations:draw()
    love.graphics.pop()
end

function Entity:update(game, dt)
    self.animations:update(dt)
end

return Entity