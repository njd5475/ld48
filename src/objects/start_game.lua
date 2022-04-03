
local StartGame = GameObject:derive('StartGame')

function StartGame:draw(game)
    GameObject.draw(self, game)
    love.graphics.push()
    SetColor('buttonBackground')
    local m = 10
    love.graphics.setFont(LogoMidFont)
    local len = love.graphics:getFont():getWidth(self.message)
    love.graphics.rectangle("fill", self:getX()-m, self:getY()-m, len+2*m, self:getHeight()+2*m)
    SetColor('buttonForeground')
    love.graphics.print(self.message, self:getX(), self:getY()+love.graphics:getFont():getHeight())
    SetColor('white')
    love.graphics.pop()
end

function StartGame:update(game, dt)
    GameObject.update(self, game, dt)
    if inside(self:getBounds(), love.mouse.getX(), love.mouse.getY()) then
        local isdown = love.mouse.isDown(1)

        if self.lastDown and not love.mouse.isDown(1) then
            game:changeState('GameState')
        end

        self.lastDown = isdown
    end
end

function StartGame:getBounds()
    return {x=self:getX(), y=self:getY(), w=self:getWidth(), h=self:getHeight()}
end

function StartGame:_init(x, y, w, h)
    GameObject._init(self)
    self.x, self.y, self.width, self.height = x, y, w, h
    self.getX = function(s) return s.x end
    self.getY = function(s) return s.y end
    self.getWidth = function(s) return s.width end
    self.getHeight = function(s) return s.height end
    self.message = "Stop the Summoning"
end

return StartGame