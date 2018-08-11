
local State = require('engine.class')()

function State:_init(name)
  assert(name, "States need unique names!")
  self.name = name
  self.objects = {}
  self.types = {}
end

function State:init(game)
end

function State:draw(game)
  for _, go in pairs(self.objects) do
    go:draw(game)
  end
end

function State:update(game, dt)
  local toRemove = {}
  for _, go in pairs(self.objects) do
    if not go:dead() then
      go:update(game, dt)
    else
      table.insert(toRemove, go)
    end
  end

  if #toRemove > 0 then
    for _, rm in pairs(toRemove) do
        self:remove(rm)
    end
  end
end


function State:withinRange(x, y, rangeSq, type)
  local results = {}
  local objs = self.objects
  if type then
    objs = self.types[type]
  end

  if objs then
    for _, o in pairs(objs) do
      local cx, cy = o:boundsCenter()
      local dsq = distSq(cx, cy, x, y)
      print("Checked " .. cx .. ", " .. cy .. " " .. x .. ", " .. y .. " dist " .. dsq)
      if (rangeSq+o:boundsRadiiSq()) >= dsq then
        table.insert(results, o)
      end
    end
  end

  return results
end

function State:getName()
  return self.name
end

function State:add(o)
  if o.dead and o.id and not o:dead() then
    self.objects[o:id()] = o
    if not self.types[o:type()] then
      self.types[o:type()] = {}
    end
    self.types[o:type()][o:id()] = o
  else
    print("Err: Game only accepts non-dead game objects")
  end
end

function State:remove(go)
  self.objects[go:id()] = nil
  self.types[go:type()][go:id()] = nil
end

return State
