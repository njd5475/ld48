
local success, failure, running = 'Success', 'Failure', 'Running'

local Selector = function(selectors)
  return function(context, dt)
    for condition, child in ipairs(selectors) do
      if condition(context, dt) then
        return child(context, dt)
      end
    end
    return failure
  end
end

local Sequence = function(...)
  local args = {...}
  local state = { status=running, i=1 }
  return function(context, dt)
    if state.status == running then
      local v = args[state.i]
      state = {status=v(context, dt), i=state.i}
    elseif state.status == failure then
      return failure
    elseif state.status == success and state.i >= #args then
      return success
    elseif state.status == success and state.i < #args then
      state.i = state.i + 1
      local v = args[state.i]
      state.status = v(context, dt)
    end
  end
end

local Delay = function(delay, child)
  return function (context, dt)
    print('Being delayed')
    if delay <= 0 then
      return child(context, dt)
    end
    delay = delay - dt
    return running
  end
end

local Inverter = function(child)
  return function(context, dt)
    local state = child(context, dt)
    if state ~= running then
      if state == success then
        return failure
      else
        return success
      end
    end
    return state
  end
end

return {
  success=success,
  failure=failure,
  running=running,
  Selector=Selector,
  Sequence=Sequence,
  Delay=Delay,
  Inverter=Inverter,
}