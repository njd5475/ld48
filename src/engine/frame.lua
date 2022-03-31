local Class = require('engine.class')

local Frame = Class({})

function Frame:_init(img, quad, duration, rotation, scaleX, scaleY, originX, originY)
    assert(img, "Must have an img for a frame")
    self.img = img
    self.quad = quad -- can be nil
    self.duration = duration or 1
    self.left = duration or self.duration
    self.rotation = rotation or 0
    self.scaleX = scaleX or 1
    self.scaleY = scaleY or 1
    self.originX = 0
    self.originY = 0

    if self.quad then
        self.draw = function(s)
            love.graphics.draw(s.img, s.quad, s.originX, s.originY, s.rotation, s.scaleX, s.scaleY)
        end
    else
        self.draw = function(s)
            love.graphics.draw(s.img, s.originX, s.originY, s.rotation, s.scaleX, s.scaley)
        end
    end
end

function Frame:getDuration()
    return self.duration
end

function Frame:getTimeLeft()
    return self.left
end

function Frame:isDone()
    return self.left <= 0
end

function Frame:reset()
    self.left = self.duration
end

function Frame:update(dt)
    self.left = self.left - dt
    return self:isDone()
end

return Frame