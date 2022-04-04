
local EventDisplay = require('objects.event-display')
local EventViewer = GameObject:derive('EventViewer')

function EventViewer:_init()
    GameObject._init(self)
    
end

function EventViewer:update(game, dt)
    GameObject.update(self, game, dt)
    self:init(game)
end

function EventViewer:enqueue(game, event, message, ...)
    local args = {...}
    local len = love.graphics.getFont():getWidth(message)
    game:current():add(EventDisplay(love.graphics:getWidth()/2-len/2, love.graphics:getHeight()-20, message))
end

function EventViewer:init(game)
    if self:doOnce('init') then
        local v = self
        game:on('event', function(game, ...)
            v:enqueue(game, ...)
        end)
    end
end

return EventViewer