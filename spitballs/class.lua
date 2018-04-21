
function Class(Parent)
  local Child = {}
  Child.__index = Child

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

  setmetatable(Child, inheritance)

  function Child:derive()
    return Class(self)
  end

  return Child
end

return Class
