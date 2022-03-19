local Class = require('engine.class')

local CountDownTimer = Class({})

function CountDownTimer:_init(duration)
    self.init = duration
    self.duration = duration
end

function CountDownTimer:reset()
    self.duration = self.init
end

function CountDownTimer:expired()
    return self.duration <= 0
end

function CountDownTimer:update(dt)
    print('updating cooldown')
    self.duration = math.max(0, self.duration - dt)
    return self:expired()
end

return CountDownTimer