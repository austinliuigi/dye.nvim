local M = {}

--- Clamp number between min and max value
--
---@param val number
---@param min number
---@param max number
---@return number
M.clamp = function(val, min, max)
  return math.min(max, math.max(min, val))
end

--- Wrap value between first and last
--
---@param val number
---@param low number
---@param high number
---@return number
M.wrap = function(val, low, high)
  local range = high - low + 1
  return ((val - low) % range) + low
end

--- Linearly interpolate between two numbers
--
---@param start number
---@param stop number
---@param ratio number Number determining weight of start to stop: (start) 0.0 - 1.0 (stop)
M.lerp = function(start, stop, ratio)
  return (start + ((stop - start) * ratio))
end

--- Radially interpolate between two numbers
--- source: https://gist.github.com/harrygallagher4/76434f43fcc2cf3c085c6e8dae0195c4
--
---@param start number
---@param stop number
---@param ratio number
M.rerp = function(start, stop, ratio)
  start = math.rad(start)
  stop = math.rad(stop)

  local delta = math.atan2(math.sin(stop - start), math.cos(stop - start))
  return ((math.deg(start + (delta * ratio)) + 360) % 360)
end

return M
