local M = {}

--- Check if color is given as a hex string
--
---@param color color_t
---@return boolean
M.is_hex = function(color)
  if type(color) ~= "string" then
    return false
  end

  if color:match("^#%x%x%x%x%x%x$") then
    return true
  end
  return false
end

--- Check if color is given as a base10 integer
--
---@param color color_t
---@return boolean
M.is_dec = function(color)
  if type(color) ~= "integer" then
    return false
  end

  local hex = string.format("%06x", color)
  if #hex == 6 then
    return true
  end
  return false
end

--- Check if color is given in rgb format
--
---@param color color_t
---@return boolean
M.is_rgb = function(color)
  if type(color) ~= "table" then
    return false
  end
  if #vim.tbl_keys(color) == 3 and color.r ~= nil and color.g ~= nil and color.b ~= nil then
    return true
  end
  return false
end

--- Check if color is given in hsl format
--
---@param color color_t
---@return boolean
M.is_hsl = function(color)
  if type(color) ~= "table" then
    return false
  end
  if #vim.tbl_keys(color) == 3 and color.h ~= nil and color.s ~= nil and color.l ~= nil then
    return true
  end
  return false
end

--- Check if arg is a color
--
---@param arg any
---@return boolean
M.is_color = function(arg)
  if M.is_hex(arg) or M.is_hsl(arg) or M.is_rgb(arg) then
    return true
  end
  return false
end

--- Convert color in any format to a hex string
--
---@param color color_t
---@return hex_t
M.any_to_hex = function(color)
  if not M.is_hex(color) then
    if M.is_rgb(color) then
      color = M.rgb_to_hex(color)
    elseif M.is_hsl(color) then
      color = M.hsl_to_hex(color)
    elseif M.is_dec(color) then
      color = M.dec_to_hex(color)
    end
  end
  return color
end

--- Convert color in any format to base10 format
--
---@param color color_t
---@return dec_t
M.any_to_dec = function(color)
  if not M.is_dec(color) then
    color = M.hex_to_dec(M.any_to_hex(color))
  end
  return color
end

--- Convert color in any format to hsl format
--
---@param color color_t
---@return hsl_t
M.any_to_hsl = function(color)
  if not M.is_hsl(color) then
    color = M.hex_to_hsl(M.any_to_hex(color))
  end
  return color
end

--- Convert color in any format to rgb format
--
---@param color color_t
---@return rgb_t
M.any_to_rgb = function(color)
  if not M.is_rgb(color) then
    color = M.hex_to_rgb(M.any_to_hex(color))
  end
  return color
end

M = vim.tbl_deep_extend(
  "error",
  M,
  require("dye.lib.math"),
  require("dye.lib.formats.dec"),
  require("dye.lib.formats.rgb"),
  require("dye.lib.formats.hsl")
)

return M
