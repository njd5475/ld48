require('common')

local Room = require('objects.room')
local Player = require('objects.player')
local MainMenu = State:derive()

local loop = love.audio.newSource("music/crappyloop.ogg", "stream")
loop:setVolume(0.5)
loop:setLooping(true)

function MainMenu:_init()
  State._init(self, 'MainMenu')
end

function MainMenu:cleanup(game)
  State.cleanup(game)

  loop:stop()
end

function MainMenu:init(game)
  loop:play()
  local room = Room()
  self:add(room)
  self.player=  Player(0,0,64,64)
  self:addKeyReleaseEvent('w', 'jump')
  self:addKeyPressEvent('a', 'moveLeft')
  self:addKeyPressEvent('d', 'moveRight')
  self.player:setInput('keyboard')
  room:addItem(self.player, 2, 2)
end

function MainMenu:jump(key, game)
  print("Main Menu State received a jump action")
end

function MainMenu:update(game, dt)
  State.update(self, game, dt)

end

function MainMenu:draw(game)
  love.graphics.clear()
  State.draw(self, game)
  SetColor('depthCount')
  love.graphics.setFont(LogoMidFont)
  love.graphics.print(self:getLevel(), 10, 10)
end

function MainMenu:getLevel()
  return 'Floor ' .. (self.level or 1)
end

function MainMenu:moveLeft(key, game, dt)
  self.player:moveLeft(game, dt)
end
  
function MainMenu:moveRight(key, game, dt)
  self.player:moveRight(game, dt)
end

return MainMenu
