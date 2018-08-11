require('engine.common')

local HudState = State:derive()

function HudState:_init()
  State._init(self)
  self.hud = {}
end

function HudState:addHud(o)
  if o.dead and o.id and not o:dead() then
    self.hud[o:id()] = o
  else
    print("Err: Hud only accepts non-dead game objets")
  end
end

function HudState:draw(game)
  State.draw(self, game)
  for _, b in pairs(self.objects) do
    b:draw(self)
  end
end

function HudState:update(game, dt)
  State.update(self, game, dt)
  for _, b in pairs(self.hud) do
    if not b:dead() then
      b:update(self, dt)
    else
      self.hud[b:id()] = nil
    end
  end
end
