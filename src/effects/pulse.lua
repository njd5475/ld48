require('engine.common')

local Pulse = GameObject:derive("Pulse")
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

function Pulse:_init(t, tw, th)
    GameObject._init(self, "Pulse")
    assert(t)
    self.type = function(self) return "Pulse-" .. t:type() end
    self.t, self.tw, self.th = t, tw or 16, th or 16
    self.on = function(s) 
        s._on = true 
        if not s:shouldLoop() and not self.reverse then
            self.reverse = true
            self.tweener = nil
        end
    end
    self.off = function(s) s._on = false end
    self.isOn = function(s) return s._on or false end
    self._loop = false
    self.loops = function(s) s._loop = true end
    self.doesNotLoop = function(s) s._loop = false end
    self.shouldLoop = function(s) return s._loop end
end

function Pulse:listen(fn)
    self.listeners = self.listeners or {}
    table.insert(self.listeners, fn)
end

function Pulse:update(game, dt)
    GameObject.update(self, game, dt)

    if self.tweener and self:isOn() then
        if self.tweener:update(dt) then
            if self:shouldLoop() then
                self.reverse = true
            else
                self:off()
            end
            for _, fn in ipairs(self.listeners or {}) do
                fn(self)
            end
        end
    end

end

function Pulse:draw(game)
    GameObject.draw(self, game)
    local g = love.graphics
    local t = self.t
    local b = t:bounds()
    local x,y = b.x, b.y

    g.push()
    self.canvas = self.canvas or buildCanvas(self.t.img, self.t.quad, self.tw, self.th)
    self.inEase = self.inEase or Tween.easing.inQuint
    self.outEase = self.outEase or Tween.easing.outQuint
    self.dur = self.dur or 0.2
    self.color = self.color or {red=1, green=1, blue=1, alpha=0}
    self.tweener = self.tweener or Tween.new(self.dur, self.color, {red=1, green=1, blue=1, alpha=1}, self.inEase)
    if self.reverse then
        if self.color.alpha == 0 then
            self.tweener = Tween.new(self.dur, self.color, {red=1, green=1, blue=1, alpha=1}, self.inEase)
        else
            self.tweener = Tween.new(self.dur, self.color, {red=1, green=1, blue=1, alpha=0}, self.outEase)
        end
        self.reverse = false
    end

    g.setColor(1,1,1,1)
    g.draw(t.img, t.quad, x, y, 0, t.scaleX, t.scaleY)
    if self:isOn() then
        g.setBlendMode("add", "alphamultiply")
        local c = self.color
        g.setColor(c.red, c.green, c.blue, c.alpha)
        g.draw(self.canvas, x, y, 0, t.scaleX, t.scaleY)
    end

    g.pop()
end

return Pulse