-- MIT License
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
      -- end of the sequence repeat
      state.i=0
      return success
    elseif state.status == success and state.i < #args then
      state.i = state.i + 1
      local v = args[state.i]
      state.status = v(context, dt)
    end
  end
end

local Delay = function(delay, child)
  local state = delay
  return function (context, dt)
    if state <= 0 then
      state = delay
      return child(context, dt)
    end
    state = math.max(0, state - dt)
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

    -- should be running so return children for replay
    return state, child 
  end
end

local Repeater = function(times, child)
  times = math.max(1, times)
  local left = times
  return function(context, dt)
    if left <= 0 then
      left = math.max(0, left - 1)
      child(context, dt) -- ignore child statuses
      return success
    else
      left = times -- reset
      return failure
    end
  end
end

return {
  success=success,
  failure=failure,
  running=running,
  Selector=Selector,
  Sequence=Sequence,
  Repeater=Repeater,
  Delay=Delay,
  Inverter=Inverter,
}