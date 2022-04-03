local Behaviors = require('engine.behavior')

local findClosest = function(me, propName, objType)
    return function(ctx, dt)
        if not me[propName] then
            local minDist = 30000^2 -- some large number
            local objects = ctx:getObjectsOfType(objType)
            for _, o in pairs(objects) do
                local d = distSq(o:getX(), o:getY(), me:getX(), me:getY())
                if d < minDist then
                    me[propName] = o
                    minDist = d
                end
            end
        end

        if me[propName] then
            return Behaviors.success
        else
            print('Could not find Obelisk')
            return Behaviors.failure
        end
    end
end

local moveTo = function(me, propName, speedProp, minDistProp)
    return function(ctx, dt)
        local o = me[propName]
        local speed = me[speedProp]
        local minDist = me[minDistProp]
        if not o then
            print('No object for ' .. propName)
            return Behaviors.failure
        end

        local dist = distSq(o:getX(), o:getY(), me:getX(), me:getY())
        if dist > minDist then
            local dir = Vec(o:getX(), o:getY()):sub(Vec(me:getX(), me:getY())):normalize()
            local delta = dir:mult(speed * dt)
            me.x = me.x + delta.x
            me.y = me.y + delta.y
            return Behaviors.running
        else
            return Behaviors.success
        end
    end
end

return {
    findClosest=findClosest,
    moveTo=moveTo,
}