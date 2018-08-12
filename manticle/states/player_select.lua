require('common')

local Match = require('states.match')
local PlayerSelect = State:derive()

local img = love.graphics.newImage("images/middlebar1.png")

function PlayerSelect:_init()
  State._init(self, "PlayerSelect")
  self.img = img
  self.barCross = love.graphics.newImage("images/barscross.png")
  self.players = {}
  for c=1,8 do
    table.insert(self.players, Player(0,0,16,32))
  end
end

function PlayerSelect:init(game)
  self.quad = love.graphics.newQuad(0, 0, 16, game.bounds.h, img:getDimensions())
  local x,y,w,h=0,0,game.bounds.w/2-5,game.bounds.h/2-5
  self.availables = {}
  self.selections = {}
  for i=0,3 do
    y = math.floor(i / 2)
    x = i - (y*2)
    local s = Selection(1+x*(w+8),1+y*(h+8),w,h)
    table.insert(self.availables, s)
    self:add(s)
  end
  self.joysticks = love.joystick.getJoysticks()
end

function PlayerSelect:draw(game)
  State.draw(self, game)
  love.graphics.draw(self.img, self.quad, game.bounds.w/2-8, 0, 0, 1, 1)
  love.graphics.push()
  love.graphics.translate(0, game.bounds.h/2+8)
  love.graphics.rotate(-math.pi/2)
  love.graphics.draw(self.img, self.quad, 0, 0, 0, 1, 2)
  love.graphics.pop()
  love.graphics.draw(self.barCross, game.bounds.w/2-self.barCross:getWidth()/2, game.bounds.h/2-self.barCross:getHeight()/2, 0, 1, 1)

  if self.allPlayersReady then
    if self.countDown then
      love.graphics.setFont(LogoFont)
      local msg = (math.floor(self.countDown))
      love.graphics.print(msg, game.bounds.w/2-LogoFont:getWidth(msg), game.bounds.h/2)
    end
  end
end

function PlayerSelect:update(game, dt)
  State.update(self, game, dt)
  local assigned = {}
  self.someKeyCheck = self.someKeyCheck or {}
  for i, joy in pairs(self.joysticks) do
    local someInput = false
    if not self.someKeyCheck[joy] then
      for _, key in pairs(joyInputs) do
        if joy:isGamepadDown(key) then
          self.someKeyCheck[joy] = {wasDown = true, key=key}
        end
      end
    else
      someInput = self.someKeyCheck[joy].wasDown and not joy:isGamepadDown(self.someKeyCheck[joy].key)
    end

    if someInput then
      local s = self.availables[1]
      table.remove(self.availables, 1)
      s:setInput(joy, "joystick", self.players)
      table.insert(self.selections, s)
      table.insert(assigned, i)
    end
  end

  for _, i in pairs(assigned) do
    self.joysticks[i] = nil
  end

  if not self.mouseHasBeenSelected then
    for i=1,4 do
      local isButDown = love.mouse.isDown(i)
      if self['button' .. i] and not isButDown then
        local s = self.availables[1]
        table.remove(self.availables, 1)
        s:setInput(nil, "mouse", self.players)
        table.insert(self.selections, s)
        self.mouseHasBeenSelected = true
      end
      self['button' .. i] = isButDown
    end
  end

  if not self.keyboardHasBeenSelected then
    if self.keyToSelectKeyBoardWasDown and not love.keyboard.isDown('q') then
      local s = self.availables[1]
      table.remove(self.availables, 1)
      s:setInput(nil, "keyboard", self.players)
      table.insert(self.selections, s)
      self.keyboardHasBeenSelected = true
    end
    self.keyToSelectKeyBoardWasDown = love.keyboard.isDown('q')
  end

  if #self.availables == 0 then
    local ready = true
    for _, s in pairs(self.selections) do
      ready = ready and s:selected()
    end

    if ready then
      self.allPlayersReady = true
    end
  end

  if self.allPlayersReady and (not self.countDown or self.countDown > 0) then
    self.countDown = (self.countDown or 10) - dt
  end

  if self.countDown and self.countDown < 0 then
    local chosenPlayers = {}
    for _, s in pairs(self.selections) do
      table.insert(chosenPlayers, s:getSelection())
    end
    game:addState(Match(chosenPlayers))
    game:changeState('Match')
  end
end

return PlayerSelect
