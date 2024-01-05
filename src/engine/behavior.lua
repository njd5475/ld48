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
  local state = nil
  return function(context, dt)
    -- if state.status == running then
    --   local v = args[state.i] -- run current
    --   state = {status=v(context, dt), i=state.i}
    --   -- return running
    -- elseif state.status == success and state.i < #args then
    --   state.i = state.i + 1 -- next
    --   local v = args[state.i]
    --   state.status = running
    --   -- return running
    -- elseif state.status == failure then
    --   state.i=1 -- end of the sequence repeat
    --   state.status = running
    --   return failure
    -- elseif state.status == success and state.i >= #args then
    --   state.i=1 -- end of the sequence repeat
    --   state.status=running
    --   return success
    -- end
    local i = 1
    local status = success
    if state and state.status == running then
      i = state.i
    end

    while (status == success or status == running) and i <= #args do
      local v = args[i]
      status = v(context, dt)
      if status == failure then
        return status
      end
      if status == running then
        state = {status=running, i=i} -- OPT: don't have to recreate if necessary
        return running
      end
      if status ~= success then
        status = success
      end
      i = i + 1
    end

    return success
  end
end

local Delay = function(delay, child)
  local state = delay
  return function (context, dt)
    if state <= 0 then
      state = delay --reset
      if child then
        return child(context, dt)
      end
      return success
    end
    state = math.max(0, state - dt)
    return running
  end
end

local Inverter = function(child)
  return function(context, dt)
    local state = child(context, dt)
    if not(state == running) then
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