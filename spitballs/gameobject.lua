
local GameObject = require("class")()
require('utils')

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
GameObject.kill = function(o) o._dead = true end
GameObject.boundsX = function() return 0 end
GameObject.boundsY = function() return 0 end
GameObject.boundsWidth = function() return 0 end
GameObject.boundsHeight = function() return 0 end
GameObject.boundsCenter = function(o)
  return o:boundsX() + o:boundsWidth() / 2, o:boundsY() + o:boundsHeight()/2
end
GameObject.feet = function(o) return {{x=o.x, y=o.y}} end
GameObject.boundsRadiiSq = function(o)
  return distSq(o:boundsX()+o:boundsWidth()/2,
    o:boundsY()+o:boundsHeight()/2, o:boundsX(), o:boundsY())
end
GameObject.bounds = function(o) return {x=o:boundsX(), y=o:boundsY(), w=o:boundsWidth(), h=o:boundsHeight()} end
GameObject.type = function(o) return (o._type or "none") end
GameObject.derive = function(o, type)
  local newClass = Class(o)
  if type then
    newClass._type = type
  end
  return newClass
end

return GameObject
