require('common')

local RampTest = State:derive()
local Builders = require('objects.builders')

function buildCanvas(img, quad, tw, th)
    local canvas = love.graphics.newCanvas(tw, th)
    canvas:setFilter('linear', 'nearest')
    love.graphics.setCanvas(canvas)
    love.graphics.draw(img, quad, 0, 0, 0, 1, 1)
    local stmode, stalphamode = love.graphics.getBlendMode()
    love.graphics.setBlendMode('add', 'alphamultiply')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, tw, th)
    love.graphics.setCanvas()
    love.graphics.setBlendMode(stmode, stalphamode)
    return canvas
end

function RampTest:_init()
    State._init(self, "RampTest")
end

function RampTest:update(game, dt)
    State.update(self, game, dt)

    if self.tweener then
        if self.tweener:update(dt) then
            self.reverse = true
        end
    end

end

function RampTest:draw(game)
    State.draw(self, game)
    local g = love.graphics
    local t = self.t
    local b = t:bounds()

    self.canvas = self.canvas or buildCanvas(self.t.img, self.t.quad, 16, 16)
    self.inEase = self.inEase or Tween.easing.inQuint
    self.outEase = self.outEase or Tween.easing.outQuint
    self.dur = self.dur or 1
    self.color = self.color or {red=1, green=1, blue=1, alpha=0}
    self.tweener = self.tweener or Tween.new(self.dur, self.color, {red=1, green=1, blue=1, alpha=1}, self.inEase)
    if self.reverse then
        print("Reversing")
        if self.color.alpha == 0 then
            self.tweener = Tween.new(self.dur, self.color, {red=1, green=1, blue=1, alpha=1}, self.inEase)
        else
            self.tweener = Tween.new(self.dur, self.color, {red=1, green=1, blue=1, alpha=0}, self.outEase)
        end
        self.reverse = false
    end

    g.setColor(1,1,1,1)
    g.draw(t.img, t.quad, 0, 0, 0, t.scaleX, t.scaleY)
    g.setBlendMode("add", "alphamultiply")
    local c = self.color
    g.setColor(c.red, c.green, c.blue, c.alpha)
    g.draw(self.canvas, 0, 0, 0, 8, 8)
end

function RampTest:init(game)
    self.t = Builders.buildHeart(16*20, 16*20, 128, 128)
end

return RampTest