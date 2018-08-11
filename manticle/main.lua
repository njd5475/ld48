
local initState = require('states.spitball_game')()
local Game = require("engine.game")(initState)
require('hud.playerhud')
require('objects.tester')
require('objects.catgenerator')

require('levelloader')(initState, Game)
