
local MinionSpawner = GameObject:derive('MinionSpawner')

local pulse = function(duration, fn)
    local timer = duration
    return function(game, dt)
        timer  = timer - dt
        if timer <= 0 then
            fn(game, dt)
            timer = duration
        end
    end
end

function MinionSpawner:_init(room)
    GameObject._init(self)
    self.room = room
    self.spawnPoints = {}
end

function MinionSpawner:add(EnemyType, point, chance, duration)
    local pulseFn = pulse(duration, function(game,dt)
        love.math.random(chance) 
    end)
    table.insert(self.spawnPoints, {
        spawn=function(game, dt)

        end
    })
end

function MinionSpawner:update(game, dt)
    GameObject.update(self, game, dt)
    self.timer = (self.timer or 1) - dt
    if self.timer <= 0 then
        local e = self.room:placeEnemy1()
        game:add(e)
        self.timer = 1
    end
end

return MinionSpawner