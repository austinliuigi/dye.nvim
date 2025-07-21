local lib = require("dye.lib.formats.hsl.lib")
local M = {}

--- Convert hex string to hsl components
--
---@param hex hex_t
---@return hsl_t
M.hex_to_hsl = function(hex)
  local h, s, l = unpack(lib.hex_to_hsluv(hex))
  return { h = h, s = s, l = l }
end

--- Convert hsl components to hex string
--
---@param hsl hsl_t
---@return hex_t hex
M.hsl_to_hex = function(hsl)
  return lib.hsluv_to_hex({ hsl.h, hsl.s, hsl.l })
end

return M
