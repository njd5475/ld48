
local StartGame = require('objects.start_game')
local MainMenu = State:derive()

local function loadImg(file)
    local img = love.graphics.newImage(file)
    img:setFilter('nearest', 'nearest')
    return img
end

local background1 = loadImg('images/summon-01.png')
local background2 = loadImg('images/summon-02.png')
local background3 = loadImg('images/summon-03.png')

function MainMenu:draw(game)
    love.graphics.push()
    love.graphics.scale(1.15, 1.15)
    for _, bkg in pairs(self.backgrounds) do
        self:drawCentered(bkg)
    end
    love.graphics.pop()
    State.draw(self, game)
end

function MainMenu:drawCentered(bkg)
    local w, h = self:getDimensions()
    local img = bkg.img
    local s = bkg.size
    local varX, varY = s*bkg.props.dw, s*bkg.props.dh
    love.graphics.draw(img, varX, varY, 0, ((w+varX*2)/img:getWidth()) , ((h+varY*2)/img:getHeight()))
end

function MainMenu:getDimensions()
    return love.graphics:getWidth(), love.graphics:getHeight()
end

function MainMenu:update(game, dt)
    State.update(self, game, dt)
    for _, bkg in pairs(self.backgrounds) do
        if bkg.tween:update(dt) then
            local newBase = bkg.tween.target
            bkg.tween = Tween.new(love.math.random(bkg.dur), bkg.props, bkg.base, bkg.tween.easing)
            bkg.base = newBase
        end
    end
end

function MainMenu:init(game)

    local bkg1, bkg2, bkg3 = {dw=-1,dh=-1}, {dw=-1,dh=-1}, {dw=-1,dh=-1}
    self.backgrounds = {
        {img=background1, dur=5, size=5, base={dw=-1,dh=-1}, props=bkg1, tween=Tween.new(5, bkg1, {dw=0,dh=0}, Tween.easing.inSine)},
        {img=background2, dur=5, size=5, base={dw=-1,dh=-1}, props=bkg2, tween=Tween.new(5, bkg2, {dw=0,dh=0}, Tween.easing.outSine)},
        {img=background3, dur=5, size=5, base={dw=-1,dh=-1}, props=bkg3, tween=Tween.new(5, bkg3, {dw=0,dh=0}, Tween.easing.inCubic)},
    }
    local sw, sh = self:getDimensions()
    self:add(StartGame(sw/2, sh/4, 300, 50))
end

function MainMenu:_init()
    State._init(self, 'MainMenu')
end

return MainMenu