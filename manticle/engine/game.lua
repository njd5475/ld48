
local Game = require("engine.class")()

require('engine.utils')

function Game:_init(startState)
  assert(startState, "Cannot start a game with a nil state!")
  self.states = {}
  local me = self
  love.draw = function() me:draw() end
  love.update = function(dt) me:update(dt) end
  self.bounds = {
    x = 0,
    y = 0,
    w = love.graphics:getWidth(),
    h = love.graphics:getHeight()
  }
  love.keyreleased = function(key)
    if key == 'escape' then
      love.event.quit()
    elseif key == 's' then
      local screenshot = love.graphics.newScreenshot();
      screenshot:encode('png', os.time() .. '.png');
    end
  end
  self:addState(startState)
  self:changeState(startState:getName())
end

function Game:addState(state)
  self.states[state:getName()] = state
end

function Game:current()
  return self.currentState
end

function Game:changeState(newState)
  assert(newState, "Cannot switch to a nil state!")
  assert(self.states[newState], "The game has no state named " .. newState)
  if self.currentState then
    self.currentState:cleanup(self, self.states[newState])
  end
  self.oldState = self.currentState
  self.currentState = self.states[newState]
  self.currentState:init(self, self.oldState)
end

function Game:add(go)
  self:current():add(go)
end

function Game:withinRange(x, y, rangeSq, type)
  return self:current():withinRange(x, y, rangeSq, type)
end

function Game:draw()
  self.currentState:draw(self)
end

function Game:update(dt)
  self.currentState:update(self, dt)
end

function Game:outside(go)
  return not collides(self.bounds, go:bounds())
end

return Game
