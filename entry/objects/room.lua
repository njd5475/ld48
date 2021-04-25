require('engine.common')

local Room = GameObject:derive('Room')
local Stairs = require('objects.stairs')
local Wall = require('objects.wall')

function Room:_init(x,y,w,h)
  GameObject._init(self)
  self.items = {}
  self.props = {w=10, h=10, tileW=64, tileH=64}
  self:buildFrame()
  self:placeStairs()
end

function Room:getWidth()
  return self.props.w
end

function Room:getHeight()
  return self.props.h
end

function Room:getTileWidth()
  return self.props.tileW
end

function Room:getTileHeight()
  return self.props.tileH
end

function Room:buildFrame()
  local roomW, roomH = self:getWidth(), self:getHeight()
  local tileW, tileH = self:getTileWidth(), self:getTileHeight()
  for i=1,roomH do
    for j=1,roomW do
      local draw = false
      if i == 1 or i == roomH then
        draw = true
      end
      if j == 1 or j == roomW then
        draw = true
      end
      if draw then
        local wall = Wall(0, 0, tileW, tileH)
        self:addItem(wall, j, i)
      end
    end
  end
end

function Room:getIndex(j, i)
  return j .. ',' .. i
end

function Room:getItems(j, i)
  return self.items[self:getIndex(j,i)]
end

function Room:addItem(item, j, i)
  assert(not self:getItems(j, i))
  self.items[self:getIndex(j,i)] = { item=item,
    x=j,
    y=i
  }
end

function Room:placeStairs()
  local tileW, tileH = self:getTileWidth(), self:getTileHeight()
  local rx, ry = 0, 0
  local added = false
  repeat 
    rx, ry = self:getRandomTile() 
    local there = self:getItems(rx, ry)
    if not there or there._type == 'Wall' then
      local stairs = Stairs(0, 0, tileW, tileH)
      self:addItem(stairs, rx, ry)
      added = true
    end
  until added
end

function Room:getRandomTile()
  return math.floor(love.math.random() * (self:getWidth()-1) + 1), math.floor(love.math.random() * (self:getHeight()-1) + 1)
end

function Room:draw(game)
  GameObject.draw(self, game)

  love.graphics.push()
  for k, i in pairs(self.items) do
    love.graphics.push()
    love.graphics.translate(i.x*self:getTileWidth(), i.y*self:getTileHeight())
    i.item:draw(game)
    love.graphics.pop()
  end
  love.graphics.pop()
end

function Room:update(game, dt)
  GameObject.update(game, dt)

  for k, i in ipairs(self.items) do
    i.item:update(game, dt)
  end
end

return Room
