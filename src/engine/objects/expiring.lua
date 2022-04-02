
local Expiring = GameObject:derive('Expiring')

function Expiring:_init(timeout)
    GameObject._init(self)
    self.timeout = math.max(0, timeout)
end

function Expiring:update(game, dt)
    GameObject.update(self, game, dt)
    
    self.timeout = self.timeout - dt
    if self.timeout <= 0 then
        self:kill()
    end
end

return Expiring