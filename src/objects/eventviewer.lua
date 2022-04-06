
local EventDisplay = require('objects.event-display')
local EventViewer = GameObject:derive('EventViewer')

function EventViewer:_init()
    GameObject._init(self)
    self.backlog = {}
    self.last = nil
end

function EventViewer:update(game, dt)
    GameObject.update(self, game, dt)
    self:init(game)
    if (not self.last or self.last:dead()) and not self:empty() then
        local msg = self:dequeue()
        if msg then
            local len = love.graphics.getFont():getWidth(msg)
            self.last = EventDisplay(2, love.graphics:getWidth()/2-len/2, love.graphics:getHeight()-20, msg)
            game:current():add(self.last)
        end
    end
end

function EventViewer:dequeue()
    if not self:empty() then
        local msg = self.backlog[1]
        table.remove(self.backlog, 1)
        return msg
    end
    return nil
end

function EventViewer:enqueue(game, event, message, ...)
    if not (message == self:peek()) then
        table.insert(self.backlog, message)
    end
end

function EventViewer:peek()
    return self.backlog[1]
end

function EventViewer:empty()
    return #self.backlog == 0
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