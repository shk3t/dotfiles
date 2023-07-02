local autocmd = vim.api.nvim_create_autocmd
local get_highlight = require("core.utils").get_highlight
local highlight = require("core.utils").highlight
local TRANSPARENCY = require("core.consts").TRANSPARENCY

vim.cmd.colorscheme("rose-pine")

local function set_transparent_bg()
  highlight("Normal", {bg = "None"})
  highlight("NormalNC", {bg = "None"})
  highlight("NonText", {bg = "None"})
  highlight("LineNr", {bg = "None"})
  highlight("SignColumn", {bg = "None"})
  highlight("TabLineFill", {bg = "None"})
  highlight("TabLine", {bg = "None"})

  vim.opt.pumblend = TRANSPARENCY
  vim.opt.winblend = TRANSPARENCY
  highlight("PmenuSel", {blend = 0})
  highlight("FloatBorder", {blend = TRANSPARENCY})

  highlight("GitSignsUntracked", {bg = "None"})
  highlight("GitSignsTopdelete", {bg = "None"})
  highlight("GitSignsChangedelete", {bg = "None"})
  highlight("GitSignsDelete", {bg = "None"})
  highlight("GitSignsChange", {bg = "None"})
  highlight("GitSignsAdd", {bg = "None"})
end

local function set_wide_border()
  local vert_split_fg = vim.api.nvim_get_hl(0, {name = "VertSplit"}).fg
  highlight("VertSplit", {bg = vert_split_fg})
end

local function setup_telescope_colors()
  local normal = get_highlight("Normal")
  local fg, bg = normal.fg, normal.bg
  local bg_alt = get_highlight("Visual").bg
  local green = get_highlight("String").fg
  local red = get_highlight("Error").fg
  highlight("TelescopeBorder", {fg = bg, bg = bg})
  highlight("TelescopeNormal", {bg = bg})
  highlight("TelescopePreviewBorder", {fg = bg, bg = bg})
  highlight("TelescopePreviewNormal", {bg = bg})
  highlight("TelescopePreviewTitle", {fg = bg, bg = green, blend = 0})
  highlight("TelescopePromptBorder", {fg = bg_alt, bg = bg_alt, blend = 0})
  highlight("TelescopePromptNormal", {fg = fg, bg = bg_alt, blend = 0})
  highlight("TelescopePromptPrefix", {fg = red, bg = bg_alt, blend = 0})
  highlight("TelescopePromptTitle", {fg = bg, bg = red, blend = 0})
  highlight("TelescopeResultsBorder", {fg = bg, bg = bg})
  highlight("TelescopeResultsNormal", {bg = bg})
  highlight("TelescopeResultsTitle", {fg = bg, bg = bg, blend = 0})
  highlight("TelescopeSelection", {blend = 0})
  highlight("TelescopeSelectionCaret", {blend = 0})
end

local function define_dap_signs()
  vim.fn.sign_define("DapBreakpoint", {text = "󰪥", texthl = "Error"})
  vim.fn.sign_define("DapStopped", {
    text = "ඞ",
    texthl = "Error",
    linehl = "CursorLine",
  })
  vim.fn.sign_define("DapBreakpointCondition", {
    text = "󰘥",
    texthl = "WarningMsg",
  })
  vim.fn.sign_define("DapLogPoint", {text = "󰗖", texthl = "MoreMsg"})
end

local colorscheme_setups = {
  ["default"] = function()
    set_wide_border()
    highlight("CursorLineNr", {bold = true})
    set_transparent_bg()
    define_dap_signs()
    setup_telescope_colors()
  end,
  ["rose-pine"] = function() require("rose-pine").setup({disable_italics = true}) end,
  ["calvera"] = function() vim.g.calvera_borders = true end,
}

local function setup_colors()
  colorscheme_setups.default()
  for colorscheme, setup in pairs(colorscheme_setups) do
    if vim.g.colors_name == colorscheme then
      setup()
      break
    end
  end
end

autocmd({"Colorscheme", "SourcePost"}, {
  callback = setup_colors
})
