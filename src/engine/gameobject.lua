
local GameObject = require("engine.class")()
require('engine.utils')

_GameObjectCount = 0

function GameObject:_init()
  _GameObjectCount = _GameObjectCount + 1
  self._id = _GameObjectCount
  self._dead = false
  self._moveable = true
end

GameObject.id = function(o) return o._id end
GameObject.draw = function(game) end
GameObject.dead = function(o) return o._dead end
GameObject.update = function(o, game, dt) end
GameObject.collide = function(o, gobj) end
GameObject.kill = function(o) o._dead = true end
GameObject.moveable = function(o) return o._moveable end
GameObject.stop = function(o) o._moveable = false end
GameObject.boundsX = function(o) return 0 end
GameObject.boundsY = function(o) return 0 end
GameObject.boundsWidth = function(o) return 0 end
GameObject.boundsHeight = function(o) return 0 end
GameObject.boundsCenter = function(o)
  return o:boundsX() + o:boundsWidth() / 2, o:boundsY() + o:boundsHeight()/2
end
GameObject.doOnce = function(o, name)
  if not o['once_' .. name] then
    o['once_' .. name] = true
    return true
  end
  return false
end
GameObject.adjustToPlatform = function(o, p) end
GameObject.feet = function(o) return {{x=o.x, y=o.y}} end
GameObject.boundsRadiiSq = function(o)
  return distSq(o:boundsX()+o:boundsWidth()/2,
    o:boundsY()+o:boundsHeight()/2, o:boundsX(), o:boundsY())
end
GameObject.bounds = function(o) return {x=o:boundsX(), y=o:boundsY(), w=o:boundsWidth(), h=o:boundsHeight()} end
GameObject.type = function(o) return (o._type or "none") end
GameObject.is = function(o, ...)
  if not ... then
    return
  end

  if type(...) == 'string' then
    return ... == o:type()
  end

  for _, a in ipairs(...) do
    if a == o:type() then
      return true
    end
  end
  return false
end
GameObject.derive = function(o, type)
  local newClass = Class(o)
  if type then
    if DEBUG_TYPES then
      print("Deriving " .. type .. " from " .. (o._type or 'none'))
    end
    newClass._type = type
  end
  return newClass
end

return GameObject
