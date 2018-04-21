
local GameObject = require("class")()

_GameObjectCount = 0

function GameObject:_init()
  _GameObjectCount = _GameObjectCount + 1
  self._id = _GameObjectCount
  self._dead = false
end

GameObject.id = function(o) return o._id end
GameObject.draw = function(game) end
GameObject.dead = function(o) return o._dead end
GameObject.update = function(game, dt) end
GameObject.collide = function(gobj) end
GameObject.kill = function() o._dead = true end

return GameObject
