local consts = require("lib.consts")

local function filetype() return vim.bo.filetype end

require("lualine").setup({
  options = {
    icons_enabled = consts.ICONS_ENABLED,
    theme = "auto",
    component_separators = {left = "", right = ""},
    section_separators = {left = "", right = ""},
    disabled_filetypes = {statusline = {}, winbar = {}},
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {statusline = 1000, tabline = 1000, winbar = 1000},
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {
      {"branch", icon = ""},
      "diff",
      {
        "diagnostics",
        sources = {"nvim_diagnostic", "coc"},
        sections = {"error", "warn", "hint"},
        symbols = (function()
          local symbols = {}
          for k, v in pairs(consts.DIAGNOSTIC_SIGNS) do symbols[k] = v .. " " end
          return symbols
        end)(),
      },
    },
    lualine_c = {{"filename", path = 1}},
    lualine_x = consts.ICONS_ENABLED and {
      {"filetype", icon = true, icon_only = true, padding = {right = 0}, colored = false},
      filetype,
      -- {filetype, padding = {right = 0}},
      -- {"filetype", icon = true, icon_only = true, padding = {right = 2}, colored = false},
    } or {"filetype"},
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
