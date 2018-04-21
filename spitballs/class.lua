
function Class(Parent)
  local Class = {}
  Class.__index = Class

  local inheritance = {
    __call = function(cls, ...)
      local self = setmetatable({}, cls)
      self:_init(...)
      return self
    end,
  }

  if Parent then
    inheritance.__index = Parent
  end

  setmetatable(Class, inheritance)

  function Class:derive()
    return Class(self)
  end

  return Class
end

return Class
