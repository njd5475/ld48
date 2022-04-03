
local BossSpawner = GameObject:derive('BossSpawner')
local Boss = require('objects.boss')

function BossSpawner:_init()
    GameObject._init(self)
    self.obelisks = {}
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
                game:current():add()
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