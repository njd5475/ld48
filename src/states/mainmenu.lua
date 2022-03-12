require('common')

local Room = require('objects.room')
local Player = require('objects.player')
local Builders = require('objects.builders')
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
  self:createLevel()

  self:addKeyPressEvent('a', 'moveLeft')
  self:addKeyPressEvent('d', 'moveRight')
  self:addKeyPressEvent('w', 'moveUp')
  self:addKeyPressEvent('s', 'moveDown')
end

function MainMenu:createLevel()
  local room = Room()
  self:add(room)
  local px, py = room:getRandomEmptyTile()
  if(px < 0 or py < 0) then
    print('Could not find a place for the player')
  end
  self.player = Player(px*room:getTileWidth(), py*room:getTileHeight(),64,64)
  self.player:setInput('keyboard')
  room:addItem(self.player, px, py)
  self:add(Builders.buildHeart(16*30,16, 32, 32))
  self.room = room
end

function MainMenu:jump(key, game)
  print("Main Menu State received a jump action")
end

function MainMenu:update(game, dt)
  State.update(self, game, dt)
end

function MainMenu:moveOnDown()
  self:removeAll()
  self.level = (self.level or 1) + 1
  self:createLevel()
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
  self.player:moveLeft(game, dt, self.room)
end
  
function MainMenu:moveRight(key, game, dt)
  self.player:moveRight(game, dt, self.room)
end

function MainMenu:moveUp(key, game, dt)
  self.player:moveUp(game, dt, self.room)
end

function MainMenu:moveDown(key, game, dt)
  self.player:moveDown(game, dt, self.room)
end

return MainMenu
