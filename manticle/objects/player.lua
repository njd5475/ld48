require('engine.common')
local Player = GameObject:derive("player")

local SpitballMachine = require('objects.spitballmachine')

function Player:_init()
  GameObject._init(self)

  self.machines = {}
  for i = 1, 10 do
    self.machines[i] = SpitballMachine()
  end
end

function Player:update(game, dt)

  self:shouldPlaceMachine(game, dt)
end

function Player:draw(game)

end

function Player:shouldPlaceMachine(game, dt)
  self.placementTimeout = (self.placementTimeout or 0) - dt
  if love.mouse.isDown(1) and self.placementTimeout <= 0 and self:hasMachines() then
    local machine = self:popMachine()
    machine:place(love.mouse.getX(), love.mouse.getY(), game)
    game:add(machine)
    self.placementTimeout = 1
  end
end

function Player:popMachine()
  return table.remove(self.machines, #self.machines)
end

function Player:hasMachines()
  return #self.machines > 0
end

return Player
