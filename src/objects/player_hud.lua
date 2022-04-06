
local PlayerHud = GameObject:derive('PlayerHud')

function PlayerHud:_init(player)
    GameObject._init(self)
    self.player = player
end

function PlayerHud:draw(game)
    local health, maxHealth = self:getHealthStats()
    local x,y,w,h = 30, 40, 200, 50
    local m = 5 -- margin
    if not self.player:dead() then
        SetColor('playerHealthBackground')
        love.graphics.rectangle('fill', x-m, y-m, w+m*2, h+m*2)
        SetColor('playerHealthForeground')
        love.graphics.rectangle('fill', x, y, w * (health/maxHealth) ,h)
    end
end

function PlayerHud:getHealthStats()
    return self.player:getHealth(), self.player:getMaxHealth()
end

return PlayerHud