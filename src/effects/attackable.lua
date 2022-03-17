require('common')

local Attackable = GameObject:derive("Attackable")

function Attackable:_init(obj, attackItem)
    GameObject._init(self)
    self.obj = obj
    self.attackItem = attackItem
end

function Attackable:attack(obj)
    obj:damage(self.attackItem:damage())
end

function Attackable:draw(game, room)
    GameObject.draw(self)
    self.obj:draw(game, room)
end

function Attackable:update(game, dt, room)
    GameObject.update(self, game, dt)

end

return Attackable