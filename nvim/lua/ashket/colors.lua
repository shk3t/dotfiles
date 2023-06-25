local M = {}
local autocmd = vim.api.nvim_create_autocmd
local highlight = require("ashket.utils").highlight

vim.cmd("colorscheme rose-pine")

local function set_transparent_bg()
  highlight(0, "Normal", {bg = "None"})
  highlight(0, "NormalNC", {bg = "None"})
  highlight(0, "NonText", {bg = "None"})
  highlight(0, "LineNr", {bg = "None"})
  highlight(0, "SignColumn", {bg = "None"})
  highlight(0, "TabLineFill", {bg = "None"})
  highlight(0, "TabLine", {bg = "None"})

  vim.opt.pumblend = 15
  vim.opt.winblend = 15
  highlight(0, "PmenuSel", {blend = 0})

  highlight(0, "GitSignsUntracked", {bg = "None"})
  highlight(0, "GitSignsTopdelete", {bg = "None"})
  highlight(0, "GitSignsChangedelete", {bg = "None"})
  highlight(0, "GitSignsDelete", {bg = "None"})
  highlight(0, "GitSignsChange", {bg = "None"})
  highlight(0, "GitSignsAdd", {bg = "None"})
end

local function set_wide_border()
  local vert_split_fg = vim.api.nvim_get_hl(0, {name = "VertSplit"}).fg
  highlight(0, "VertSplit", {bg = vert_split_fg})
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
    highlight(0, "CursorLineNr", {bold = true})
    set_transparent_bg()
    define_dap_signs()
  end,
  ["rose-pine"] = function() require("rose-pine").setup({disable_italics = true}) end,
  ["calvera"] = function() vim.g.calvera_borders = true end,
}

M.setup_colors = function()
  colorscheme_setups.default()
  for colorscheme, setup in pairs(colorscheme_setups) do
    if vim.g.colors_name == colorscheme then
      setup()
      break
    end
  end
end
M.setup_colors()

return M
