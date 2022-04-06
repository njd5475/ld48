
local BossSpawner = GameObject:derive('BossSpawner')
local Boss = require('objects.boss')

function BossSpawner:_init()
    GameObject._init(self)
    self.obelisks = {}
end

function BossSpawner:getPercentageComplete()
    local total = 0
    local max = 0
    for _, o in ipairs(self.obelisks) do
        total = total + o:getCharge()
        max = max + o:getMaxCharge()
    end
    return total/max
end

function BossSpawner:draw(game)

    local w = 800
    local h = 14
    local x, y = love.graphics.getWidth()/2-w/2, h*2
    SetColor('summoningBackground')
    love.graphics.rectangle('fill', x, y, w, h)
    SetColor('summoningForeground')
    love.graphics.rectangle('fill', x, y, w*self:getPercentageComplete(), h)
end

function BossSpawner:update(game, dt)
    GameObject.update(self, game, dt)

    local shouldSpawn = true
    for _, o in ipairs(self.obelisks) do
        shouldSpawn = shouldSpawn and o:isCharged()
    end

    if shouldSpawn then
        if self:doOnce('spawnBoss') then
            local room = game:current():getObjectsOfType('Room')
            if #room > 0 then
                room = room[1]
                local boss = room:placeBoss()
                Emit('Summoning Complete HE IS HERE!')
                game:current():add(boss)
            else
                print('I could not find a room to spawn boss in')
            end
        end
    end
end

function BossSpawner:getNewObelisk(room)
    local o = room:placeObelisk()
    self:addObelisk(o)
    return o
end

function BossSpawner:addObelisk(o)
    table.insert(self.obelisks, o)
end

return BossSpawner