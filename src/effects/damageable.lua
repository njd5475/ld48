require('common')

local Damageable = GameObject:derive()

function Damageable:_init(obj, health, onDamage)
    GameObject._init(self)
    self.obj = obj
    self.health = health
    self.onDamage = onDamage

    self.getObj = function(s) return s.obj end
    self.getHealth = function(s) return s.health end
end

function Damageable:dead()
    return self.health <= 0
end

function Damageable:update(game, dt, room)
    GameObject.update(self, game, dt, room)
    self.obj:update(game, dt, room)
end

function Damageable:damage(amount)
    self.health = math.max(0, self.health - amount)
    self.onDamage(self)
end

function Damageable:draw(game, room)
    GameObject.draw(self, game, room)
    self.obj:draw(game, room)
end

return Damageable