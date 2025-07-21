local lib = require("dye.lib")
local operations = require("dye.operations")
local M = vim.deepcopy(operations)

--- Convert a hex string into a color class
--
---@param hex hex_t
---@return Color
local function wrap_color(hex)
  return setmetatable({
    hex = hex,
  }, {
    __index = function(tbl, key)
      if key == "dec" then
        return lib.hex_to_dec(tbl.hex)
      elseif key == "rgb" then
        return lib.hex_to_rgb(tbl.hex)
      elseif key == "hsl" then
        return lib.hex_to_hsl(tbl.hex)
      elseif key == "r" then
        return tbl.rgb.r
      elseif key == "g" then
        return tbl.rgb.g
      elseif key == "b" then
        return tbl.rgb.b
      elseif key == "h" then
        return tbl.hsl.h
      elseif key == "s" then
        return tbl.hsl.s
      elseif key == "l" then
        return tbl.hsl.l
      end

      if operations[key] ~= nil then
        return function(...)
          return wrap_color(operations[key](tbl.hsl, ...))
        end
      end
    end,
    __tostring = function(tbl)
      return tbl.hex
    end,
    __call = function()
      return hex
    end,
  })
end

--- Wrap a highlight table returned from vim.api.nvim_get_hl s.t. each attribute's color is wrapped in a color class
--
---@param hl vim.api.keyset.get_hl_info Table of highlight attributes
---@param group string Name of highlight group
local function wrap_hl(hl, group)
  return setmetatable({}, {
    __index = function(_, attr)
      if hl[attr] == nil then
        vim.notify(
          string.format('attribute "%s" for highlight group "%s" does not exist', attr, group),
          vim.log.levels.ERROR,
          { title = "Dye" }
        )
        return nil
      else
        return wrap_color(lib.dec_to_hex(hl[attr]))
      end
    end,
  })
end

setmetatable(M, {
  -- dye.<hl_group> returns a wrapped highlight table
  __index = function(_, hl_group)
    local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false, create = false })
    if not vim.tbl_isempty(hl) then
      return wrap_hl(hl, hl_group)
    else
      vim.notify(
        string.format('highlight group "%s" does not exist', hl_group),
        vim.log.levels.ERROR,
        { title = "Dye" }
      )
      return nil
    end
  end,
})

return M
