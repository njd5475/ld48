local Basic = require('objects.basic')

local img = require('ld48sheet')

function inSheet(img, col, row, size)
    return function(x, y, w, h, onCollision)
        local obj = Basic({x=x, y=y, w=w or size, h=h or size}, {x=size*col, y=size*row, w=size, h=size}, img)
        function obj:doCollision(hitObj, game)
            print("Do Collision")
            if onCollision then
                onCollision(self, hitObj, game)
            end
        end
        return obj
    end
end

return {
    buildStairs=inSheet(img, 4, 0, 16),
    buildHeart=inSheet(img, 6, 2, 16)
}