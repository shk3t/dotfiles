local autocmd = vim.api.nvim_create_autocmd
local sign_define = vim.fn.sign_define
local get_highlight = require("lib.main").get_highlight
local highlight = require("lib.main").highlight
local consts = require("lib.consts")

vim.cmd.colorscheme("rose-pine")

local function set_transparent_bg()
  highlight("Normal", { bg = "NONE" })
  highlight("NormalNC", { bg = "NONE" })
  highlight("NonText", { bg = "NONE" })
  highlight("LineNr", { bg = "NONE" })
  highlight("SignColumn", { bg = "NONE" })
  highlight("TabLineFill", { bg = "NONE" })
  highlight("TabLine", { bg = "NONE" })

  vim.opt.pumblend = consts.TRANSPARENCY
  vim.opt.winblend = consts.TRANSPARENCY
  highlight("Pmenu", { blend = consts.TRANSPARENCY })
  highlight("PmenuSel", { blend = 0 })
  highlight("FloatBorder", { blend = consts.TRANSPARENCY })
  highlight("NormalFloat", { blend = consts.TRANSPARENCY })

  highlight("GitSignsUntracked", { bg = "NONE" })
  highlight("GitSignsTopdelete", { bg = "NONE" })
  highlight("GitSignsChangedelete", { bg = "NONE" })
  highlight("GitSignsDelete", { bg = "NONE" })
  highlight("GitSignsChange", { bg = "NONE" })
  highlight("GitSignsAdd", { bg = "NONE" })
end

local function set_wide_border()
  local vert_split_fg = vim.api.nvim_get_hl(0, { name = "WinSeparator" }).fg
  highlight("WinSeparator", { bg = vert_split_fg })
end

local function clear_spell_check_highlights()
  highlight("SpellBad", { undercurl = false })
  highlight("SpellCap", { undercurl = false })
  highlight("SpellRare", { undercurl = false })
  highlight("SpellLocal", { undercurl = false })
end

local function setup_telescope_colors()
  local normal = get_highlight("Normal")
  local fg, bg = normal.fg, normal.bg
  local bg_alt = get_highlight("Visual").bg
  local green = get_highlight("String").fg
  local red = get_highlight("Error").fg
  highlight("TelescopeBorder", { fg = bg, bg = bg })
  highlight("TelescopeNormal", { bg = bg })
  highlight("TelescopePreviewBorder", { fg = bg, bg = bg })
  highlight("TelescopePreviewNormal", { bg = bg })
  highlight("TelescopePreviewTitle", { fg = bg, bg = green, blend = 0 })
  highlight("TelescopePromptBorder", { fg = bg_alt, bg = bg_alt, blend = 0 })
  highlight("TelescopePromptNormal", { fg = fg, bg = bg_alt, blend = 0, link = 0 })
  highlight("TelescopePromptPrefix", { fg = red, bg = bg_alt, blend = 0 })
  highlight("TelescopePromptTitle", { fg = bg, bg = red, blend = 0 })
  highlight("TelescopeResultsBorder", { fg = bg, bg = bg })
  highlight("TelescopeResultsNormal", { bg = bg })
  highlight("TelescopeResultsTitle", { fg = bg, bg = bg, blend = 0 })
  highlight("TelescopeSelection", { blend = 0 })
  highlight("TelescopeSelectionCaret", { blend = 0 })
end

local normal = get_highlight("Normal")
local g_fg, g_bg = normal.fg, normal.bg

local function setup_mark_colors()
  highlight("MarkSignNumHL", { link = "NONE" })
end

local function define_diagnostic_signs()
  local diagnostic_signs = {
    ["DiagnosticSignError"] = consts.DIAGNOSTIC_SIGNS.error,
    ["DiagnosticSignWarn"] = consts.DIAGNOSTIC_SIGNS.warn,
    ["DiagnosticSignInfo"] = consts.DIAGNOSTIC_SIGNS.info,
    ["DiagnosticSignHint"] = consts.DIAGNOSTIC_SIGNS.hint,
  }
  for sign, text in pairs(diagnostic_signs) do
    sign_define(sign, {
      text = text,
      texthl = sign,
    })
  end
end

local function define_dap_signs()
  sign_define("DapBreakpoint", { text = "󰪥", texthl = "Error" })
  sign_define("DapStopped", {
    text = "ඞ",
    texthl = "Error",
    linehl = "CursorLine",
  })
  sign_define("DapBreakpointCondition", { text = "󰘥", texthl = "WarningMsg" })
  sign_define("DapLogPoint", { text = "󰗖", texthl = "MoreMsg" })
end

local colorscheme_setups = {
  ["default"] = function()
    set_wide_border()
    highlight("CursorLineNr", { bold = true })
    if consts.TRANSPARENCY > 0 then
      set_transparent_bg()
    end
    define_diagnostic_signs()
    define_dap_signs()
    setup_mark_colors()
    setup_telescope_colors()
    clear_spell_check_highlights()
  end,
  ["rose-pine"] = function() end,
  ["calvera"] = function()
    vim.g.calvera_borders = true
  end,
}

local function setup_colors()
  colorscheme_setups.default()
  for colorscheme, setup in pairs(colorscheme_setups) do
    if vim.g.colors_name == colorscheme then
      setup()
      break
    end
  end
  if consts.ICONS_ENABLED then
    require("nvim-web-devicons").setup()
  end
end

autocmd({ "Colorscheme", "SourcePost" }, { callback = setup_colors })
