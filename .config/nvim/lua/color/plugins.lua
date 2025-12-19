local sign_define = vim.fn.sign_define
local autocmd = vim.api.nvim_create_autocmd
local get_highlight = require("lib.base.highlight").get_highlight
local highlight = require("lib.base.highlight").highlight

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

local function setup_harpoon_colors()
  local normal = get_highlight("Normal")
  local fg, bg = normal.fg, normal.bg
  local red = get_highlight("Error").fg

  local harpoon_ns = vim.api.nvim_create_namespace("harpoon")
  highlight("FloatTitle", { fg = bg, bg = red, blend = 0, bold = false, link = 0 }, harpoon_ns)

  autocmd("FileType", {
    pattern = "harpoon",
    callback = function()
      vim.api.nvim_win_set_hl_ns(0, harpoon_ns)
    end,
  })
end

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

define_dap_signs()
autocmd("Colorscheme", {
  callback = function()
    setup_telescope_colors()
    setup_harpoon_colors()
  end,
})
