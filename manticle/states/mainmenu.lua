require('common')

local MainMenu = State:derive()

local LogoFont = love.graphics.newFont("fonts/press-start-2p/PressStart2P-Regular.ttf", 56)

function MainMenu:_init()
  State._init(self, 'MainMenu')
end

function MainMenu:init(game)
  local brickW, brickH = 16*3, 16*3
  for x=0,math.ceil(game.bounds.w/(brickW)) do
    self:add(HouseBrick(x*brickW,0, brickW, brickH))
    self:add(Vine(x*brickW, 0, brickW, brickH))
    self:add(HouseBrick(x*brickW, math.floor(game.bounds.h/brickH)*brickH, brickW, brickH))
  end

  for y=0,math.floor(game.bounds.h/brickH) do
    self:add(HouseBrick(0, (y+1)*brickH, brickW, brickH))
    self:add(HouseBrick(math.ceil(game.bounds.w/brickW)*brickW-brickW, (y+1)*brickH, brickW, brickH))
  end
end

function MainMenu:update(game, dt)
  State.update(self, game, dt)
  local done = true
  for _, brick in pairs(self.types['HouseBrick']) do
    local covered = brick:coveredWithVine(game)
    done = done and covered
  end
  if done then
    self.vinesCovered = true
  end

  self.increment = (self.increment or 0) + 1
end

function MainMenu:draw(game)
  State.draw(self, game)
  love.graphics.setColor(255, 255, 255, 255)

  if self.vinesCovered then
    local oldFont = love.graphics.getFont()
    love.graphics.setFont(LogoFont)
    local m = love.graphics.getFont():getWidth("Mantical")
    love.graphics.print("Manticle", game.bounds.w/2-m/2, game.bounds.h/2-LogoFont:getHeight())
    love.graphics.setFont(oldFont)
  end
end

return MainMenu
