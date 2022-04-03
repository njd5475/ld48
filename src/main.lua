
require('common')

local initState = require('states.mainmenu')()
local game = Game(initState)

function Emit(message)
    game:emit('event', message)
end