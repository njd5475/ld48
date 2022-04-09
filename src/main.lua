
require('common')

local GameState = require('states.game_state')
local initState = require('states.mainmenu')()
local game = Game(initState)
game:addState(GameState())

function Emit(message)
    game:emit('event', message)
end

local startTime = love.timer.getTime()

function getTimeStr(time)
    local parts = {}
    local diff = time
    local part = 0
    while math.floor(diff/60) > 0 do
        local part = math.floor(diff / 60)
        diff = part
        table.insert(parts, diff - part*60)
        print('Diff=' .. diff .. ' part=' .. part .. ' time=' .. time)
    end

    local times = {'minute', 'hour'}
    local timeStr = diff .. ' seconds'
    local start = 1
    for _, p in ipairs(parts) do
        if p > 0 then
            timeStr = p .. ' ' .. times[start] .. 's, '.. timeStr
            start = start + 1
        end
    end
    return timeStr
end

game.shutdownHook = function(game)
    local diff = love.timer.getTime() - startTime
    
    print('Exiting after ' .. getTimeStr(3*3600+60+60))
end