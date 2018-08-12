require('engine.common')

local Selection = GameObject:derive("Selection")
local font = love.graphics.newFont("fonts/press-start-2p/PressStart2P-Regular.ttf", 12)

function Selection:_init(x,y,w,h)
  GameObject._init(self)
  self.x, self.y, self.w, self.h = x, y, w, h
  self.msg = "Press any key to select"
  self.mode = "selectable"
  self.selectionIndex = 1
end

function Selection:draw(game)
  love.graphics.setFont(font)
  love.graphics.setColor(33, 33, 33, 255)
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.setLineWidth(2)
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
  if self:selectable() then
    local msg = self.msg
    love.graphics.setColor(240, 240, 240, 255)
    love.graphics.print(msg, self.x + self.w/2 - font:getWidth(msg)/2, self.y + self.h/2)
  end

  if self:choosable() then
    local numPlayers = #self.players
    local h = (self.h-(0.1*self.h))/numPlayers
    local x,y = self.w/2-(numPlayers*((self.w-(self.w*0.1))/numPlayers))/2,self.h*0.05
    local sep = self.w*0.01
    love.graphics.setColor(255, 255, 255, 255)
    for i, p in pairs(self.players) do
        local w = h*(self.h/self.w)
        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        love.graphics.translate(x,y)
        love.graphics.scale(w/p.w,h/p.h)
        p:draw(game)
        if i == self.selectionIndex then
          love.graphics.rectangle('line', 0,0, p.w, p.h)
        end
        love.graphics.pop()
        x = x + p.w + sep
    end
  end

  if self:animating() or self:selected() then
    local h = (self.h-(0.1*self.h))/#self.players
    local w = h*(self.h/self.w)
    local x,y = self.w/2-(#self.players*((self.w-(self.w*0.1))/#self.players))/2,self.h*0.05
    local sep = self.w*0.01
    love.graphics.setColor(255, 255, 255, 255)
    p = self:getSelection()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.translate(x,y)
    love.graphics.scale(self.animate.sx, self.animate.sy)
    p:draw(game)
    if i == self.selectionIndex then
      love.graphics.rectangle('line', 0, 0, p.w, p.h)
    end
    love.graphics.pop()
    x = x + p.w + sep
  end
end

function Selection:update(game, dt)
  if self:choosable() then
    self:checkInputs(game, dt)
  end

  if self:animating() then
    local complete = self.animator:update(dt)
    if complete then
      self.mode = "selected"
    end
  end
end

function Selection:left()
  self.selectionIndex = self.selectionIndex - 1
  if self.selectionIndex < 1  then
    self.selectionIndex = #self.players
  end
end

function Selection:right()
  self.selectionIndex = self.selectionIndex + 1
  if self.selectionIndex > #self.players then
    self.selectionIndex = 1
  end
end

function Selection:select()
  local h = (self.h-(0.1*self.h))/#self.players
  local w = h*(self.h/self.w)
  local p = self:getSelection()
  self.animate = {sx=w/p.w, sy=h/p.h}
  self.animator = Tween.new(1, self.animate, {sx=((self.h*0.80)/p.h), sy=(self.h*0.80)/p.h}, Tween.easing.outCubic)
  self.mode = "animate"
  p:setInput(self.inputType, self.obj)
end

function Selection:unselect()
  self.mode = 'choosable'
end

function Selection:getSelection()
  return self.players[self.selectionIndex]
end

function Selection:setInput(obj, inputType, players)
  self.mode = "choosable"
  self.obj = obj
  self.inputType = inputType
  if inputType == "joystick" then
    self.checkInputs = function(me,game,dt)
      local joy = me.obj
      if me:choosable() then
        if me._dpLeftWasDown and not joy:isGamepadDown('dpleft') then
          me:left()
        elseif me._dpRightWasDown and not joy:isGamepadDown('dpright') then
          me:right()
        end
        me._dpLeftWasDown = joy:isGamepadDown('dpleft')
        me._dpRightWasDown = joy:isGamepadDown('dpright')

        if me._selectButtonPressed and not joy:isGamepadDown('a') then
          print("Should be selected")
          me:select()
        end
        me._selectButtonPressed = joy:isGamepadDown('a')
      end

      if me:selected() then
        if me._undoSelectionButton and not joy:isGamepadDown('b') then
          me:unselect()
        end
        me._undoSelectionButton = joy:isGamepadDown('b')
      end
    end
  elseif inputType == "mouse" then
    self.checkInputs = function(me, game, dt)
      local h = (self.h-(0.1*self.h))/#self.players
      local w = h*(self.h/self.w)
      if me._leftClickButtonWasDown and not love.mouse.isDown(1) then
        me:select()
      end
      me._leftClickButtonWasDown = love.mouse.isDown(1)

      if me._rightClickButtonWasDown and not love.mouse.isDown(2) then
        me:right()
      end
      me._rightClickButtonWasDown = love.mouse.isDown(2)
    end
  elseif inputType == "keyboard" then
    self.checkInputs = function(me, game, dt)
      if me._leftKeyWasDown and not love.keyboard.isDown('a') then
        me:left()
      end
      me._leftKeyWasDown = love.keyboard.isDown('a')

      if me._rightKeyWasDown and not love.keyboard.isDown('d') then
        me:right()
      end
      me._rightKeyWasDown = love.keyboard.isDown('d')

      if me._selectKeyWasDown and not love.keyboard.isDown('q') then
        me:select()
      end
      me._selectKeyWasDown = love.keyboard.isDown('q')
    end
  end
  self.players = players
end

function Selection:selectable()
  return self.mode == "selectable"
end

function Selection:choosable()
  return self.mode == "choosable"
end

function Selection:selected()
  return self.mode == "selected"
end

function Selection:animating()
  return self.mode == "animate"
end

return Selection
