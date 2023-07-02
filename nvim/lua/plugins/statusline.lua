local DIAGNOSTIC_SIGNS = require("utils.consts").DIAGNOSTIC_SIGNS

require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "auto",
    component_separators = {left = "", right = ""},
    section_separators = {left = "", right = ""},
    disabled_filetypes = {statusline = {}, winbar = {}},
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {statusline = 500, tabline = 500, winbar = 500},
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        sources = {"nvim_diagnostic", "coc"},
        sections = {"error", "warn", "hint"},
        symbols = (function()
          local symbols = {}
          for k, v in pairs(DIAGNOSTIC_SIGNS) do symbols[k] = v .. " " end
          return symbols
        end)(),
      },
    },
    lualine_c = {{"filename", path = 1}},
    lualine_x = {"filetype"},
    lualine_y = {"%l:%v"},
    lualine_z = {"%LL"},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"%l:%v"},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
