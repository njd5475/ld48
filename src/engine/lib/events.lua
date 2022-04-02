local Events = Class({}, 'events')

function Events:_init()
  self.handlers = {}
end

function Events:on(event, handler)
  local h = self.handlers
  local bus = self
  local handle = h[event]
  
  local last = handle

  -- push new function for chained calls
  handle = {last=last}
  handle.func = function(bus, ...)
    if last then last.func(bus, ...) end
    if self.off then handler(bus, ...) end
  end
  
  handle.ref = handle
  handle.last = last
  handle.off = false

  h[event] = handle
end

function Events:off(event)
  self.handlers[event] = nil
end

function Events:emit(event, ...)
  local fn = self.handlers[event]
  if fn then fn.func(self, ...) end
end

return Events