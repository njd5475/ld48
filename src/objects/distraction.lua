
local Distraction = GameObject:derive('distraction')

function Distraction:_init(player, dir, distance)
    GameObject._init(self)
    self.velocity = initVelocity or 10
    -- apply force
    self.velocity = self.velocity
    self.accel = force
    self.dir = dir:normalize()
    self.player = player
    self.x, self.y = player:getX(), player:getY()
    self.target = dir:mult(distance)
    self.shifter = Tween.new(1.0, self, {x=self.x+self.target:getX(), y=self.y+self.target:getY()}, Tween.inOutQuad)
end

function Distraction:damage()
end

function Distraction:draw()
    local g = love.graphics
    setColor('buttonForeground')
    g.rectangle('fill', self.x, self.y, 20, 20)
    g.print(self.velocity, self.x + 30, self.y)
end

function Distraction:update(g, dt)
    -- dx = dx0 + v0 + v * dt + a * dt ^ 2
    if self.shifter:update(dt) then
        local found = g:withinRange(self.x, self.y, 150^2, "Enemy")
        if found and #found > 0 then
            for _, f in ipairs(found) do
                print("Trying to distract enemy")
                f.shinyObject = self
                if f.foundPlayer then
                    f.foundPlayer = nil
                end
            end
        end
    end
end

return Distraction

