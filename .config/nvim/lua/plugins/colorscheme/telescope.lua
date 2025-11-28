local get_highlight = require("lib.utils").get_highlight
local highlight = require("lib.utils").highlight
local autocmd = vim.api.nvim_create_autocmd

local function setup_telescope_colors()
  local normal = get_highlight("Normal")
  local fg, bg = normal.fg, normal.bg
  local bg_alt = get_highlight("Visual").bg
  local green = get_highlight("String").fg
  local red = get_highlight("Error").fg
  highlight("TelescopeBorder", { fg = bg, bg = bg, link = 0 })
  highlight("TelescopeNormal", { bg = bg, link = 0 })
  highlight("TelescopePreviewBorder", { fg = bg, bg = bg, link = 0 })
  highlight("TelescopePreviewNormal", { bg = bg, link = 0 })
  highlight("TelescopePreviewTitle", { fg = bg, bg = green, blend = 0, link = 0 })
  highlight("TelescopePromptBorder", { fg = bg_alt, bg = bg_alt, blend = 0, link = 0 })
  highlight("TelescopePromptNormal", { fg = fg, bg = bg_alt, blend = 0, link = 0 })
  highlight("TelescopePromptPrefix", { fg = red, bg = bg_alt, blend = 0, link = 0 })
  highlight("TelescopePromptTitle", { fg = bg, bg = red, blend = 0, link = 0 })
  highlight("TelescopeResultsBorder", { fg = bg, bg = bg, link = 0 })
  highlight("TelescopeResultsNormal", { bg = bg, link = 0 })
  highlight("TelescopeResultsTitle", { fg = bg, bg = bg, blend = 0, link = 0 })
  highlight("TelescopeSelection", { blend = 0, link = 0 })
  highlight("TelescopeSelectionCaret", { blend = 0, link = 0 })
end

autocmd("Colorscheme", { callback = setup_telescope_colors })

return { setup = setup_telescope_colors }
