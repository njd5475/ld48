require('common')

local Room = require('objects.room')
local Player = require('objects.player')
local Builders = require('objects.builders')
local GameState = State:derive()
local EventViewer = require('objects.eventviewer')
local BossSpawner = require('objects.boss_spawner')

local loop = love.audio.newSource("music/crappyloop.ogg", "stream")
loop:setVolume(0.5)
loop:setLooping(true)

function GameState:_init()
  State._init(self, 'GameState')
end

function GameState:cleanup(game)
  State.cleanup(game)

  loop:stop()
end

function GameState:init(game)
  loop:play()
  self:createLevel()

  self:addKeyPressEvent('a', 'moveLeft')
  self:addKeyReleaseEvent('a', 'stopMovingLeft')
  self:addKeyPressEvent('d', 'moveRight')
  self:addKeyReleaseEvent('d', 'stopMovingRight')
  self:addKeyPressEvent('w', 'moveUp')
  self:addKeyReleaseEvent('w', 'stopMovingUp')
  self:addKeyPressEvent('s', 'moveDown')
  self:addKeyReleaseEvent('s', 'stopMovingDown')

  self:add(EventViewer())
end

function GameState:createLevel()
  local room = Room()
  self:add(room)
  local px, py = room:getRandomEmptyTile()
  if(px < 0 or py < 0) then
    print('Could not find a place for the player')
  end
  self.player = Player(px*room:getTileWidth(), py*room:getTileHeight(),64,64)
  self.player:setInput('keyboard')
  --room:addItem(self.player, px, py)
  self:add(self.player)
  local spawner = BossSpawner()
  local o = spawner:getNewObelisk(room)
  self:add(o)
  self:add(spawner)
  self.room = room
end

function GameState:jump(key, game)
  print("Main Menu State received a jump action")
end

function GameState:update(game, dt)
  State.update(self, game, dt)
  if self.player:doOnce('GameStarted') then
    game:emit('event', 'Game Started')
  end
  self.room:update(game, dt)
end

function GameState:moveOnDown()
  self:removeAll()
  self.level = (self.level or 1) + 1
  self:createLevel()
end

function GameState:draw(game)
  love.graphics.clear(1/255, 0/255, 3/255, 0)
  State.draw(self, game)
  SetColor('depthCount')
  love.graphics.setFont(LogoMidFont)
end


function GameState:moveLeft(key, game, dt)
  self.player:moveLeft(game, dt, self.room)
end

function GameState:stopMovingLeft(key, game, dt)
  self.player:stopMovingLeft(game, dt, self.room)
end
  
function GameState:moveRight(key, game, dt)
  self.player:moveRight(game, dt, self.room)
end

function GameState:stopMovingRight(key, game, dt)
  self.player:stopMovingRight(game, dt, self.room)
end

function GameState:moveUp(key, game, dt)
  self.player:moveUp(game, dt, self.room)
end

function GameState:stopMovingUp(key, game, dt)
  self.player:stopMovingUp(game, dt, self.room)
end

function GameState:moveDown(key, game, dt)
  self.player:moveDown(game, dt, self.room)
end

function GameState:stopMovingDown(key, game, dt)
  self.player:stopMovingDown(game, dt, self.room)
end

return GameState
