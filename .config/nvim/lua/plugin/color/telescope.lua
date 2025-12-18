local autocmd = vim.api.nvim_create_autocmd
local get_highlight = require("lib.base.color").get_highlight
local highlight = require("lib.base.color").highlight

local function setup_telescope_colors()
  local normal = get_highlight("Normal")
  local fg, bg = normal.fg, normal.bg
  local bg_alt = get_highlight("Visual").bg
  local yellow = get_highlight("String").fg
  local red = get_highlight("Error").fg

  highlight("TelescopeSelection", { fg = "NONE", blend = 0, link = 0 })
  highlight("TelescopePromptBorder", { fg = bg_alt, bg = bg_alt, blend = 0, link = 0 })
  highlight("TelescopePromptNormal", { fg = fg, bg = bg_alt, blend = 0, link = 0 })
  highlight("TelescopePromptPrefix", { fg = red, bg = bg_alt, blend = 0, link = 0 })
  highlight("TelescopePromptTitle", { fg = bg, bg = red, blend = 0, link = 0 })
  highlight("TelescopePreviewTitle", { fg = bg, bg = yellow, blend = 0, link = 0 })
end

autocmd("Colorscheme", { callback = setup_telescope_colors })
