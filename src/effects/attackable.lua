require('engine.common')

local Attackable = GameObject:derive("Attackable")

function Attackable:_init(obj, attackItem, cooldown)
    GameObject._init(self)
    self.obj = obj
    self.attackItem = attackItem
    self.cooldown = CountDownTimer(cooldown)
end

function Attackable:attack(obj, dt)
    -- if expired damage can be dealt
    if self.cooldown:update(dt) then
        obj:damage(self.attackItem:damage())
    end
end

function Attackable:canAttack()
    return self.cooldown:expired()
end

function Attackable:draw(game, room)
    GameObject.draw(self)
    self.obj:draw(game, room)
end

function Attackable:update(game, dt, room)
    GameObject.update(self, game, dt)
    self.obj:update(game, dt, room)
end

return Attackable