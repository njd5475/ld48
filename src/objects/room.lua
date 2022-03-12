require('engine.common')

local Room = GameObject:derive('Room')
local Builders = require('objects.builders')
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

function Room:getGridCoords(x,y)
  local gridX, gridY = math.floor(x/self:getTileWidth()), math.floor(y/self:getTileHeight())
  local outofbounds = false
  if gridX < 1 or gridX > self:getWidth() then
    outofbounds =true
  end
  if gridY < 1 or gridY > self:getHeight() then
    outofbounds = true
  end
  return math.max(1, math.min(self:getWidth(), gridX)), math.max(1, math.min(self:getHeight(), gridY)), outofbounds
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
        local wall = Wall(j*tileW, i*tileH, tileW, tileH)
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

function Room:getAllCoordsBetween(x,y,x2,y2)
  local tx, ty = self:getGridCoords(x, y)
  local t2x, t2y = self:getGridCoords(x2, y2)
  local items = {}
  for i = tx, t2x do
    for j = ty, t2y do
      items[self:getIndex(i,j)] = { x=i, y=j}
    end
  end
  return items
end

function Room:getItemsForObject(object)
  local b = object:bounds()
  local tx, ty = self:getGridCoords(b.x, b.y)
  local t2x, t2y = self:getGridCoords(b.x+b.w, b.y+b.h)
  local items = nil
  for i = tx, t2x do
    for j = ty, t2y do
      local objects = self:getItems(i, j)
      if objects and not (objects == object) then
        items = items or {}
        table.insert(items, objects.item)
      end
    end
  end

  return items
end

function Room:addItem(item, j, i)
  assert(not self:getItems(j, i))
  self.items[self:getIndex(j,i)] = {
    item=item,
    x=j,
    y=i
  }
end

function Room:placeStairs()
  local tileW, tileH = self:getTileWidth(), self:getTileHeight()
  local j, i = 0, 0
  local added = false
  repeat 
    j, i = self:getRandomTile() 
    local there = self:getItems(j, i)
    if not there then
      local collide = function(stair, hitObj, game)
        print("Got a collision")
        if hitObj:is('player') then
          game:current():moveOnDown()
        end
      end
      local stairs = Builders.buildStairs(j*tileW, i*tileH, tileW, tileH, collide)
      stairs:markCollidable()
      self:addItem(stairs, j, i)
      added = true
    end
  until added
end

function Room:getRandomTile()
  return math.floor(love.math.random() * (self:getWidth()-1) + 1), math.floor(love.math.random() * (self:getHeight()-1) + 1)
end

function Room:getRandomEmptyTile()
  local j, i = 0, 0
  local checked = {}
  repeat
    j, i = self:getRandomTile()
    local skip = false
    if checked[self:getIndex(j,i)] then
      skip = true
    end
    if not skip then
      local there = self:getItems(j, i)
      if not there then
        return j, i
      end
      checked[self:getIndex(j,i)] = {}
    end
  until #checked == (self:getWidth() * self:getHeight())
  return -1, -1
end

function Room:isBlocked(object)
  local items = self:getItemsForObject(object)
  local blocked = false
  if items then
    for key, item in ipairs(items) do
      if item.isBlocking and item:isBlocking() then
        return true
      end
    end
  end
  return blocked, items
end

function Room:draw(game)
  GameObject.draw(self, game)

  love.graphics.push()
  for k, i in pairs(self.items) do
    love.graphics.push()
    --love.graphics.translate(i.x*self:getTileWidth(), i.y*self:getTileHeight())
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
