local consts = require("consts")
local lualine = require("lualine")

lualine.setup({
  options = {
    icons_enabled = consts.ICONS.ENABLED,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      { "branch", icon = consts.ICONS.ENABLED and "" },
      "diff",
      {
        "diagnostics",
        sections = { "error", "warn", "hint" },
        symbols = consts.ICONS.ENABLED and {
          error = consts.ICONS.DIAGNOSTIC.ERROR .. " ",
          warn = consts.ICONS.DIAGNOSTIC.WARN .. " ",
          info = consts.ICONS.DIAGNOSTIC.INFO .. " ",
          hint = consts.ICONS.DIAGNOSTIC.HINT .. " ",
        },
      },
    },
    lualine_c = {
      { "filename", path = 1 },
    },
    lualine_x = {
      { "%S" },
      { "searchcount", maxcount = 999 },
      {
        "lsp_status",
        icon = consts.ICONS.ENABLED and "󰒋",
        symbols = {
          spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          done = "",
          separator = "|",
        },
      },
      { "filetype", icon = consts.ICONS.ENABLED, colored = true },
    },
    lualine_y = { "%l:%v" },
    lualine_z = { "%L=" },
  },
})
