require('common')

local RampTest = State:derive()
local Builders = require('objects.builders')

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

    self.inEase = self.inEase or Tween.easing.inOutElastic
    self.outEase = self.outEase or Tween.easing.outQuint
    self.dur = self.dur or 0.5
    self.color = self.color or {red=0, green=0, blue=0, alpha=0}
    self.tweener = self.tweener or Tween.new(self.dur, self.color, {red=0.8, green=0.8, blue=0.8, alpha=1}, self.inEase)
    if self.reverse then
        print("Reversing")
        if self.color.red == 0 then
            self.tweener = Tween.new(self.dur, self.color, {red=0.8, green=0.8, blue=0.8, alpha=1}, self.inEase)
        else
            self.tweener = Tween.new(self.dur, self.color, {red=0, green=0, blue=0, alpha=0}, self.outEase)
        end
        self.reverse = false
    end

    g.clear(0,0,0,0)
    g.setBlendMode("screen", "premultiplied")
    g.setColor(1,1,1,1)
    g.draw(t.img, t.quad, 0, 0, 0, t.scaleX, t.scaleY)
    g.setBlendMode("add", "premultiplied")
    local c = self.color
    g.setColor(c.red, c.green, c.blue, c.alpha)
    g.draw(t.img, t.quad, 0, 0, 0, t.scaleX, t.scaleY)
end

function RampTest:init(game)
    self.t = Builders.buildHeart(16*20, 16*20, 32, 32)
end

return RampTest