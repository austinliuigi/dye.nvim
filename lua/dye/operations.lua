local lib = require("dye.lib")
local M = {}

--- Set the hue of a color
--
---@param color color_t Color to alter
---@param hue number Value to set the hue to (0.0-360.0)
---@return hex_t hex
function M.hue(color, hue)
  local hsl = lib.any_to_hsl(color)
  hue = lib.wrap(hue, 0, 360)
  return lib.hsl_to_hex({
    h = hue,
    s = hsl.s,
    l = hsl.l,
  })
end

--- Set the saturation of a color
--
---@param color color_t Color to alter
---@param saturation number Value to set the saturation to (0-100)
---@return hex_t hex
function M.saturation(color, saturation)
  local hsl = lib.any_to_hsl(color)
  saturation = lib.clamp(saturation, 0, 100)
  return lib.hsl_to_hex({
    h = hsl.h,
    s = saturation,
    l = hsl.l,
  })
end

--- Set the lightness of a color
--
---@param color color_t Color to alter
---@param lightness number Value to set the lightness to (0-100)
---@return hex_t hex
function M.lightness(color, lightness)
  local hsl = lib.any_to_hsl(color)
  lightness = lib.clamp(lightness, 0, 100)
  return lib.hsl_to_hex({
    h = hsl.h,
    s = hsl.s,
    l = lightness,
  })
end

--- Change hue of a color
--
---@param color color_t Color to alter
---@param val number Amount to change hue by
---@return hex_t hex
function M.rotate(color, val)
  local hsl = lib.any_to_hsl(color)
  return M.hue(hsl, hsl.h + val)
end

--- Increase the saturation of a color using lerp
--
---@param color color_t Color to alter
---@param val number Amount to increase saturation by: (current) 0.0 - 1.0 (max saturation, 100)
---@return hex_t hex
function M.saturate(color, val)
  local hsl = lib.any_to_hsl(color)
  return M.saturation(hsl, lib.lerp(hsl.s, 100, val))
end

--- Decrease the saturation of a color using lerp
--
---@param color color_t Color to alter
---@param val number Amount to decrease saturation by: (current) 0.0 - 1.0 (min saturation, 0)
---@return hex_t hex
function M.desaturate(color, val)
  local hsl = lib.any_to_hsl(color)
  return M.saturation(hsl, lib.lerp(hsl.s, 0, val))
end

--- Increase the lightness of a color using lerp
--
---@param color color_t Color to alter
---@param val number Amount to increase lightness by: (current) 0.0 - 1.0 (max lightness, 100)
---@return hex_t hex
function M.lighten(color, val)
  local hsl = lib.any_to_hsl(color)
  return M.lightness(hsl, lib.lerp(hsl.l, 100, val))
end

--- Decrease the lightness of a color using lerp
--
---@param color color_t Color to alter
---@param val number Amount to decrease lightness by: (current) 0.0 - 1.0 (min lightness, 0)
---@return hex_t hex
function M.darken(color, val)
  local hsl = lib.any_to_hsl(color)
  return M.lightness(hsl, lib.lerp(hsl.l, 0, val))
end

--- Blend two colors
--
---@param color1 color_t
---@param color2 color_t
---@param ratio number
---@return hex_t hex
function M.blend(color1, color2, ratio)
  local hsl1 = lib.any_to_hsl(color1)
  local hsl2 = lib.any_to_hsl(color2)

  local blended_hsl = {
    h = lib.rerp(hsl1.h, hsl2.h, ratio),
    s = lib.lerp(hsl1.s, hsl2.s, ratio),
    l = lib.lerp(hsl1.l, hsl2.l, ratio),
  }
  return lib.hsluv_to_hex(blended_hsl)
end

return M
