require('common')

local Match = State:derive()

function Match:_init(players)
  State._init(self, "Match")
  self.players = players
end

function Match:init(game)
  self.gridw, self.gridh = 16*3, 16*3
  self.halfGridW, self.halfGridH = self.gridw/2, self.gridh/2
  self.cols, self.rows = game.bounds.w/self.gridw, game.bounds.h/self.gridh
  local room1Bounds = self:buildRoom(0,0,10, 8)
  self:buildRoom(room1Bounds.right-self.gridw, room1Bounds.top, 10, 8)

  for _, p in pairs(self.players) do
    p.x = room1Bounds.left + 2*self.gridw
    p.y = room1Bounds.bottom - 2*self.gridh
    self:add(p)
  end
  self.testSprite = AnimatedSprite(TheSheet, {startX=1,startY=1,w=16,h=16,off={x=2,y=2}}, {3,4,3,3,5,5}, 1)

  --self.testSprite = AnimatedSprite(TheSheet, {startX=1,startY=1,w=16,h=16,off={x=2,y=2}}, {6,9,10,9,7,1}, 5)
  self:add(Manticle(self.testSprite, self.gridw*7, self.gridh*6, self.gridw, self.gridh))
  self:add(Vine(room1Bounds.left+self.gridw, room1Bounds.top+self.gridh, self.gridw, self.gridh, AnimatedSprite(TheSheet, {startX=1,startY=1,w=16,h=16,off={x=2,y=2}}, {6,9,10,9,7}, 5)))
end

function Match:buildRoom(stx, sty, w, h)
  for c=1,w do
    for r=1,h do
      if c == 1 or c == w or r == 1 or r == h then
        local x,y = stx+c*self.gridw,sty+r*self.gridh
        if #self:withinRange(x+self.halfGridW,y+self.halfGridH,self.halfGridW*self.halfGridW, "HouseBrick") == 0 then
          self:add(HouseBrick(x,y,self.gridw,self.gridh))
        end
      end
    end
  end
  return {top=sty, left=stx, bottom=h*self.gridh, right=w*self.gridw}
end

function Match:draw(game)
  State.draw(self, game)
  love.graphics.setFont(LogoMidFont)
  love.graphics.print("Players Alive: " .. #self.players, 0, 5)
end

function Match:update(game, dt)
  State.update(self, game, dt)
end

return Match
