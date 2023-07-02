local autocmd = vim.api.nvim_create_autocmd
local sign_define = vim.fn.sign_define
local get_highlight = require("utils.main").get_highlight
local highlight = require("utils.main").highlight
local TRANSPARENCY = require("utils.consts").TRANSPARENCY
local DIAGNOSTIC_SIGNS = require("utils.consts").DIAGNOSTIC_SIGNS

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

local function define_diagnostic_signs()
  local diagnostic_signs = {
    ["DiagnosticSignError"] = DIAGNOSTIC_SIGNS.error,
    ["DiagnosticSignWarn"] = DIAGNOSTIC_SIGNS.warn,
    ["DiagnosticSignInfo"] = DIAGNOSTIC_SIGNS.info,
    ["DiagnosticSignHint"] = DIAGNOSTIC_SIGNS.hint,
  }
  for sign, text in pairs(diagnostic_signs) do sign_define(sign, {
    text = text,
    texthl = sign,
  }) end
end

local function define_dap_signs()
  sign_define("DapBreakpoint", {text = "󰪥", texthl = "Error"})
  sign_define("DapStopped", {
    text = "ඞ",
    texthl = "Error",
    linehl = "CursorLine",
  })
  sign_define("DapBreakpointCondition", {text = "󰘥", texthl = "WarningMsg"})
  sign_define("DapLogPoint", {text = "󰗖", texthl = "MoreMsg"})
end

local colorscheme_setups = {
  ["default"] = function()
    set_wide_border()
    highlight("CursorLineNr", {bold = true})
    set_transparent_bg()
    define_diagnostic_signs()
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

autocmd({"Colorscheme", "SourcePost"}, {callback = setup_colors})
