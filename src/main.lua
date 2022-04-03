
require('common')

local GameState = require('states.game_state')
local initState = require('states.mainmenu')()
local game = Game(initState)
game:addState(GameState())

function Emit(message)
    game:emit('event', message)
end