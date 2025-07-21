local M = {}

--- Convert hex string to base10 representation
--
---@param hex hex_t
---@return dec_t
M.hex_to_dec = function(hex)
  hex = hex:sub(2) -- remove the leading "#"

  return tonumber(hex, 16)
end

--- Convert base10 color into corresponding hex string
--
---@param dec integer
---@return hex_t hex
M.dec_to_hex = function(dec)
  return string.format("#%06x", dec)
end

return M
