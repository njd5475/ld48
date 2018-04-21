

love.draw = function()
  love.graphics.print("I'm the Ultimate", love.graphics:getWidth()/2, love.graphics:getHeight()/2)
end

love.keyreleased = function(key)
  if key == 'escape' then
    love.event.quit()
  end
end
