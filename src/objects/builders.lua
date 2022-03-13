local Basic = require('objects.basic')

local img = require('ld48sheet')

function inSheet(type, img, col, row, size)
    return function(x, y, w, h, onCollision)
        local obj = Basic({x=x, y=y, w=w or size, h=h or size}, {x=size*col, y=size*row, w=size, h=size}, img, type)
        function obj:doCollision(hitObj, game)
            if onCollision then
                onCollision(self, hitObj, game)
            end
        end
        return obj
    end
end

return {
    buildStairs=inSheet("Stairs", img, 4, 0, 16),
    buildHeart=inSheet("Heart", img, 6, 2, 16),
    buildHeart2=inSheet("Heart2", img, 5, 2, 16),
}