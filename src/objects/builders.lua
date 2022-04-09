local Basic = require('objects.basic')

local img = require('main-sheet')

function inSheet(objType, img, col, row, size)
    return function(x, y, w, h, onCollision, ObjectType)
        ObjectType = ObjectType or Basic
        local obj = ObjectType({x=x, y=y, w=w or size, h=h or size}, {x=size*col, y=size*row, w=size, h=size}, img, objType)
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
    buildObelisk=inSheet("Obelisk", img, 0, 0, GRID_SIZE),
    buildEnemy1=inSheet("Enemy1", img, 0, 2, GRID_SIZE),
    buildEnemy2=inSheet("Enemy2", img, 0, 3, GRID_SIZE),
    buildEnemy3=inSheet("Enemy3", img, 0, 4, GRID_SIZE),
    buildDemon=inSheet("Demon", img, 1, 1, 96),
    buildProjectile=inSheet('Projectile', img, 0, 6, GRID_SIZE),
}