require('common')

local MainMenu = State:derive()
local PlayerSelect = require('states.player_select')

function MainMenu:_init()
  State._init(self, 'MainMenu')
  self.playersAvailable = {}
end

function MainMenu:init(game)
  game:addState(PlayerSelect())
  love.graphics.setFont(LogoFont)
  local brickW, brickH = 16*3, 16*3
  for x=0,math.ceil(game.bounds.w/(brickW)) do
    self:add(HouseBrick(x*brickW,0, brickW, brickH))
    self:add(Vine(x*brickW, 0, brickW, brickH))
    self:add(HouseBrick(x*brickW, math.floor(game.bounds.h/brickH)*brickH, brickW, brickH))
  end

  self.player = Player(5*brickW, 5*brickH, brickW, 2*brickH)
  self:add(self.player)

  for y=0,math.floor(game.bounds.h/brickH) do
    self:add(HouseBrick(0, (y+1)*brickH, brickW, brickH))
    self:add(HouseBrick(math.ceil(game.bounds.w/brickW)*brickW-brickW, (y+1)*brickH, brickW, brickH))
  end

  -- self:addKeyReleaseEvent('w', 'jump')
  -- self:addKeyPressEvent('a', 'moveLeft')
  -- self:addKeyPressEvent('d', 'moveRight')

  self:renumeratePlayers()
  self.player:setInput("keyboard")
  for _, joy in pairs(self.playersAvailable) do
    self.player:setInput("joystick", joy)
  end
end

function MainMenu:jump(key, game)
  print("Main Menu State received a jump action")
end

function MainMenu:moveLeft(key, game, dt)
  self.player:moveLeft(game, dt)
end

function MainMenu:moveRight(key, game, dt)
  self.player:moveRight(game, dt)
end

function MainMenu:update(game, dt)
  State.update(self, game, dt)
  local done = true
  for _, brick in pairs(self.types['HouseBrick']) do
    local covered = brick:coveredWithVine(game)
    done = done and covered
  end
  if done then
    self.vinesCovered = true
    game:listenForKey()
  end

  self:renumeratePlayers()

  if self.vinesCovered then
    if self:checkForInput(game) then
      game:stopListeningForKey()
      game:changeState('PlayerSelect')
    end
  end
end

function MainMenu:draw(game)
  State.draw(self, game)
  love.graphics.setColor(255, 255, 255, 255)

  if self.vinesCovered then
    love.graphics.setFont(LogoFont)
    local m = love.graphics.getFont():getWidth("Mantical")
    love.graphics.print("Manticle", game.bounds.w/2-m/2, game.bounds.h/2-love.graphics.getFont():getHeight())

    love.graphics.setFont(LogoRegularFont)
    local msg = "Press any button to start"
    if #self.playersAvailable > 0 then
      msg = "Someone press a button to start"
    end
    m = love.graphics.getFont():getWidth(msg)
    love.graphics.print(msg, game.bounds.w/2-m/2, game.bounds.h/2+LogoFont:getHeight())
  end

  local i = 1
  local x = 0
  local oldFont = love.graphics.getFont()
  love.graphics.setFont(LogoRegularFont)
  local f = love.graphics.getFont()
  for _, p in pairs(self.playersAvailable) do
    local x = (i-1)*16
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("fill", x, 0, 16, 16)
    love.graphics.setColor(200,200,200,255)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", x, 0, 16, 16)
    love.graphics.print(i, x+ f:getWidth(i)/2, f:getHeight()/2)
    i = i + 1
  end
  love.graphics.setFont(oldFont)
end

function MainMenu:renumeratePlayers()
  self.playersAvailable = {}
  for _, joy in pairs(love.joystick.getJoysticks()) do
    self.playersAvailable[joy] = joy
  end
end

local joyInputs = {"x","y",'a','b','back','start','leftstick','rightstick','leftshoulder','rightshoulder','dpup','dpdown','dpleft','dpright'}
function MainMenu:checkForInput(game)
  local someInput = false
  for _, joy in pairs(love.joystick.getJoysticks()) do
    for _, key in pairs(joyInputs) do
      someInput = someInput or joy:isGamepadDown(key)
    end
  end

  if not someInput then
    for m=1,4 do
      someInput = someInput or love.mouse.isDown(m)
    end
  end

  someInput = someInput or game:wasKeyPressed()
  return someInput
end

return MainMenu
