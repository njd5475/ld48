local Behaviors = require('engine.behavior')

local findClosest = function(propName, objType, me)
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

local scanFor = function(objType, rangePropName, propName, me)
    return function(ctx, dt)
        local results = ctx:withinRange(me:getX(), me:getY(), me[rangePropName], objType)
        if #results > 0 then
            me[propName] = results[1]
            return Behaviors.success
        end
        me[propName] = nil

        return Behaviors.failure
    end
end

local moveTo = function(propNameOrVec, speedProp, minDistProp, me)
    return function(ctx, dt)
        local o = me[propNameOrVec] or propNameOrVec
        local toX, toY = nil, nil
        local toXFn, toYFn = o.getX or (function() return o.x or nil end), o.getY or (function() return o.y or nil end)
        toX, toY = toXFn(o), toYFn(o)
        local speed = me[speedProp]
        local minDist = me[minDistProp]
        if not o or not toX or not toY then
            print('No object for ' .. propNameOrVec)
            return Behaviors.failure
        end

        local dist = distSq(toX, toY, me:getX(), me:getY())
        if dist > minDist then
            local dir = Vec(toX, toY):sub(Vec(me:getX(), me:getY())):normalize()
            local delta = dir:mult(speed * dt)
            me.x = me.x + delta.x
            me.y = me.y + delta.y
            return Behaviors.running
        else
            return Behaviors.success
        end
    end
end

local moveToRandomPoint = function(bounds, speedProp, minDistProp, me)
    local w = math.abs(bounds.right - bounds.left)
    local h = math.abs(bounds.top - bounds.bottom)
    local x, y = bounds.left + love.math.random(w), bounds.top + love.math.random(h)
    print('Moving to ' .. x .. ',' .. y .. ' in ' .. bounds.left .. ',' .. bounds.top .. '-' .. w .. 'x' .. h)
    return moveTo({x=x, y=y}, speedProp, minDistProp, me)
end

local emit = function(message)
    return function(ctx, dt)
        Emit(message)
        return Behaviors.success
    end
end

local attack = function(targetName, damagePropName, me)
    return function(ctx, dt)
        me[targetName]:damage(me[damagePropName])
        return Behaviors.success
    end
end

local roam = function(bounds, speedProp, minDistProp, me)
    local child = nil
    return function(ctx, dt)
        child = child or moveToRandomPoint(bounds, speedProp, minDistProp, me)
        
        local status = child(ctx, dt)
        if status == Behaviors.success then
            child = nil
        end
        return status
    end
end

local chance = function(chances)
    return function(ctx, dt)

    end
end

return {
    findClosest=findClosest,
    scanFor=scanFor,
    moveTo=moveTo,
    moveToRandomPoint=moveToRandomPoint,
    attack=attack,
    roam=roam,
    emit=emit,
}