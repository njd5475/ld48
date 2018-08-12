require('common')

local PlayerSelect = State:derive()

local img = love.graphics.newImage("images/middlebar1.png")

function PlayerSelect:_init()
  State._init(self, "PlayerSelect")
  self.img = img
  self.barCross = love.graphics.newImage("images/barscross.png")
end

function PlayerSelect:init(game)
  self.quad = love.graphics.newQuad(0, 0, 16, game.bounds.h, img:getDimensions())
  local x,y,w,h=0,0,game.bounds.w/2-5,game.bounds.h/2-5
  for i=0,3 do
    y = math.floor(i / 2)
    x = i - (y*2)
    self:add(Selection(1+x*(w+8),1+y*(h+8),w,h))
  end
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
  
end

function PlayerSelect:update(game, dt)

end

return PlayerSelect
