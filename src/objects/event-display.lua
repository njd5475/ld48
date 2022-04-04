
local EventDisplay = Expiring:derive('EventDisplay')

function EventDisplay:_init(x,y,message)
    Expiring._init(self, 2)
    self.x, self.y = x, y
    self.message = message
end

function EventDisplay:draw(game)
    Expiring.draw(self, game)
    love.graphics.push()
    SetColor('eventBackground')
    local len = love.graphics.getFont():getWidth(self.message)
    local mt, ml, mb, mr = 10, 10, 10, 10
    love.graphics.rectangle('fill', self.x-ml, self.y-mt, len+ml+mr, 20+ml+mb)
    SetColor('eventForeground')
    love.graphics.print(self.message, self.x, self.y)
    love.graphics.pop()
end

function EventDisplay:update(game, dt)
    Expiring.update(self, game, dt)
    
end


return EventDisplay