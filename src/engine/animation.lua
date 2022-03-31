local Class = require('engine.class')

local Animation = Class({})

function Animation:_init(frames, startIndex, looping)
    self.frames = {}
    for _, f in ipairs(frames) do
        self:addFrame(f)
    end
    self.startIndex = startIndex or 1
    self.looping = looping or false
    self.current = self.startIndex
    self.running = true
end

function Animation:draw()
    self:getCurrent():draw()
end

function Animation:update(dt)

    if self:getCurrent():update(dt) then
        return self:advance() -- advance should also tell us if we are done
    end
    return self:isDone()
end

function Animation:advance()
    self.current = math.min(self:getFrameCount(), self.current + 1)
    if self:isDone() and self:isLooping() then
        self:reset() -- start from the beginning of the animation
    end
    -- we need to call this again to see if we looped, since when we loop we are not done
    return self:isDone()
end

function Animation:reset()
    self.current = self.startIndex
    for _, f in ipairs(self.frames) do
        f:reset()
    end
end

function Animation:addFrame(frame)
    table.insert(self.frames, frame)
end

function Animation:play()
    self.running = true
end

function Animation:pause()
    self.running = false
end

function Animation:stop()
    self.running = false
    self:reset()
end

function Animation:getFrameCount()
    return #self.frames
end

function Animation:getCurrent()
    return self.frames[self.current]
end

function Animation:getCurrentIndex()
    return self.current
end

function Animation:isOnLastFrame()
    return self:getCurrentIndex() == self:getFrameCount()
end

function Animation:isDone()
    return self:isOnLastFrame() and self:getCurrent():isDone() -- make sure we wait till the last frame is done
end

function Animation:isLooping()
    return self.looping
end

return Animation