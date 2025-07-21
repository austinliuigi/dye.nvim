local M = {}

--- Convert hex string to rgb components
--
---@param hex hex_t
---@return rgb_t
M.hex_to_rgb = function(hex)
  hex = string.lower(hex)
  local hex_pat = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex_pat .. ")(" .. hex_pat .. ")(" .. hex_pat .. ")$"

  local r, g, b = string.match(hex, pat)
  r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
  return { r = r, g = g, b = b }
end

--- Convert rgb components to hex string
--
---@param rgb rgb_t
---@return hex_t hex
M.rgb_to_hex = function(rgb)
  return string.format("#%02X%02X%02X", rgb.r, rgb.g, rgb.b)
end

return M
