local Basic = require('objects.basic')

local img = require('ld48sheet')

function inSheet(type, img, col, row, size)
    return function(x, y, w, h, onCollision)
        local obj = Basic({x=x, y=y, w=w or size, h=h or size}, {x=size*col, y=size*row, w=size, h=size}, img, type)
        function obj:doCollision(hitObj, game, dt)
            if onCollision then
                onCollision(self, hitObj, game, dt)
            end
        end
        return obj
    end
end

function wrap(buildFn, wrapFn, args)
    return function(x, y, w, h, onCollision)
        local obj = buildFn(x,y,w,h,onCollision)
        return wrapFn(obj, args)
    end
end

return {
    buildStairs=inSheet("Stairs", img, 4, 0, 16),
    buildHeart=inSheet("Heart", img, 5, 2, 16),
    buildHeart2=inSheet("Heart2", img, 4, 2, 16),
    buildHeartBroken=inSheet("HeartBroken", img, 6, 2, 16),
    buildSpider=inSheet("Spider", img, 7, 1, 16),
}