# dye.nvim

`dye.nvim` is a neovim plugin that provides functions for applying operations on colors.
It also has an ergonomic API for referencing and applying color operations on existing highlights.
This is useful to:

1. create dynamic highlights that work across different colorschemes
2. maintain a consistent theme by deriving colors from an existing palette

## Usage

Usage of the API dye provides is in the form `dye.<hl_group>.<hl_attr>[.(<format>|<operation>)]`.

- `<hl_group>`
    - `:h highlight-groups`

- `<hl_attr>`
    - `:h nvim_set_hl`

- `<format>`
    - see documentation on formats below

- `<operation>`
    - see documentation on operations below

### Example
```lua
local dye = require("dye")

vim.api.nvim_set_hl(0, "Directory", { fg = "#8AB3B5" })

--################################################################################
-- API
--################################################################################

----------------------------------------------------------------------------------
-- Output color in specific format
----------------------------------------------------------------------------------
vim.print(dye.Directory.fg.hex) -- #8ab3b5
vim.print(dye.Directory.fg.rgb) -- { r = 138, g = 179, b = 181 }
vim.print(dye.Directory.fg.hsl) -- { h = 196.34988474472, s = 38.869732480022, l = 70.161132085461 }

----------------------------------------------------------------------------------
-- Extract specific component of color
----------------------------------------------------------------------------------
vim.print(dye.Directory.fg.r) -- 138
vim.print(dye.Directory.fg.g) -- 179
vim.print(dye.Directory.fg.b) -- 181

vim.print(dye.Directory.fg.h) -- 196.34988474472
vim.print(dye.Directory.fg.s) -- 38.869732480022
vim.print(dye.Directory.fg.l) -- 70.161132085461

----------------------------------------------------------------------------------
-- Apply operations using dot notation (easily chainable)
----------------------------------------------------------------------------------
vim.print(dye.Directory.fg.hue(10).hex) -- #d29fa1
vim.print(dye.Directory.fg.rotate(100).hex) -- #c1a0cd

vim.print(dye.Directory.fg.saturation(50).hex) -- #7eb5b8
vim.print(dye.Directory.fg.saturate(0.75).hex) -- #48bcc0
vim.print(dye.Directory.fg.desaturate(0.75).hex) -- #a4adae

vim.print(dye.Directory.fg.lightness(30).hex) -- #374a4b
vim.print(dye.Directory.fg.lighten(0.75).hex) -- #cdf0f2
vim.print(dye.Directory.fg.darken(0.75).hex) -- #212d2e

vim.print(dye.Directory.fg.blend(dye.Normal.bg, 0.7)) -- #535742


--################################################################################
-- Functions
--################################################################################

----------------------------------------------------------------------------------
-- Apply operations using function notation
----------------------------------------------------------------------------------
vim.print(dye.hue("#8ab3b5", 10)) -- #d29fa1
vim.print(dye.rotate("#8ab3b5", 100)) -- #c1a0cd

vim.print(dye.saturation("#8ab3b5", 50)) -- #7eb5b8
vim.print(dye.saturate("#8ab3b5", 0.75)) -- #48bcc0
vim.print(dye.desaturate("#8ab3b5", 0.75)) -- #a4adae

vim.print(dye.lightness("#8ab3b5", 30)) -- #374a4b
vim.print(dye.lighten("#8ab3b5", 0.75)) -- #cdf0f2
vim.print(dye.darken("#8ab3b5", 0.75)) -- #212d2e

vim.print(dye.blend("#8ab3b5", "#3b3228", 0.7)) -- #535742
```

## Formats

Formats are different ways that a color can be described. The following formats are supported by `dye.nvim`:

### Hex

Hex is a format where a color is represented as a **string** containing hexadecimal values in the form `"#RRGGBB"`,
where `RR`, `GG`, and `BB` are the hexadecimal values of the red, green, and blue components respectively.

### Decimal

Decimal is a format where a color is represented as a single **integer** value. This value is the base10 representation of the hexadecimal value of the color.
Neovim displays colors in this form when displaying highlight info through calls to `vim.api.nvim_get_hl`.

### RGB

RGB is a representation of color that splits it up into its red, green, and blue components.
It's a standard representation of color for additive color sources.

`dye.nvim` represents RGB as a lua **table** in the following form:

```lua
{
  r = [0-255], -- red component
  g = [0-255], -- green component
  b = [0-255], -- blue component
}
```

### HSL

HSL is a representation of color that splits it up into its hue, saturation, and lightness.
It's useful for describing colors in a way that is intuitive for humans to grasp.

`dye.nvim` represents HSL as a lua **table** in the following form:

```lua
{
  h = [0.0-360.0], -- angle in degrees on the color wheel spectrum
  s = [0.0-100.0], -- percentage of saturation; 0% is a shade of gray, 100% is a full color
  l = [0.0-100.0], -- percentage of lightness; 0% is black, 100% is white
}
```

## Operations

Operations are functions you can apply on colors to manipulate them.

### dye.hue()

`dye.hue(color, value)`

Set the hue of a color to a given value.

#### Parameters

`color`: color_t

The color to apply the change in hue on.

`value`: number

The value in degrees to set the hue to.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after changing the hue.

### dye.rotate()

`dye.rotate(color, value)`

Change the hue of a color relative to its current value. It "rotates" the hue on the color wheel by a certain amount.

#### Parameters

`color`: color_t

The color to rotate the hue on.

`value`: number

The value in degrees to rotate the hue by.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after changing the hue.

### dye.saturation()

`dye.saturation(color, value)`

Set the saturation percentage of a color to a given value.

#### Parameters

`color`: color_t

The color to apply the change in saturation on.

`value`: number

The percentage value to set the saturation to.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after changing the saturation.

### dye.saturate()

`dye.saturate(color, value)`

Increase the saturation of a color relative to its current value.

#### Parameters

`color`: color_t

The color to apply the increase in saturation on.

`value`: number

The normalized amount to increase the saturation by. A value of 0.0 will leave the saturation unchanged,
a value of 1.0 will increase to saturation to 100%, and values in between apply a proportional increase.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after changing the saturation.

### dye.desaturate()

`dye.desaturate(color, value)`

Decrease the saturation of a color relative to its current value.

#### Parameters

`color`: color_t

The color to apply the decrease in saturation on.

`value`: number

The normalized amount to decrease the saturation by. A value of 0.0 will leave the saturation unchanged,
a value of 1.0 will decrease to saturation to 0%, and values in between apply a proportional decrease.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after changing the saturation.

### dye.lightness()

`dye.lightness(color, value)`

Set the lightness percentage of a color to a given value.

#### Parameters

`color`: color_t

The color to apply the change in lightness on.

`value`: number

The percentage value to set the lightness to.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after changing the lightness.

### dye.lighten()

`dye.lighten(color, value)`

Increase the lightness of a color relative to its current value.

#### Parameters

`color`: color_t

The color to apply the increase in lightness on.

`value`: number

The normalized amount to increase the lightness by. A value of 0.0 will leave the lightness unchanged,
a value of 1.0 will increase to lightness to 100%, and values in between apply a proportional increase.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after changing the lightness.

### dye.darken()

`dye.darken(color, value)`

Decrease the lightness of a color relative to its current value.

#### Parameters

`color`: color_t

The color to apply the decrease in lightness on.

`value`: number

The normalized amount to decrease the lightness by. A value of 0.0 will leave the lightness unchanged,
a value of 1.0 will decrease to lightness to 0%, and values in between apply a proportional decrease.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after changing the lightness.

### dye.blend()

`dye.blend(color1, color2, ratio)`

Blend two colors together.

#### Parameters

`color1`: color_t

The first color to blend with the second.

`color2`: color_t

The second color to blend with the first.

`ratio`: number

The ratio of the amount of color2 to color1. A value of 0.0 will result in color1,
a value of 1.0 will result in color2, and values in between apply a proportional blend.

#### Returns

`result`: hex_t

The resulting color, in hexadecimal format, after blending the two colors.
