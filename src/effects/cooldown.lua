require('common')

local Cooldown = GameObject:derive('Cooldown')

function Cooldown:_init(duration)
    GameObject._init(self)
    self.cooling = true
    self.duration = duration
end

function Cooldown:cooling()
    return self.cooling
end

function Cooldown:draw(game, room)
    GameObject.draw(self, game)
end

function Cooldown:update(game, dt, room)
    GameObject.update(game, dt, room)
end

return Cooldown