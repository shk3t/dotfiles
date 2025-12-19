local consts = require("consts")
local lualine = require("lualine")
local state = require("state")

lualine.setup({
  options = {
    icons_enabled = consts.ICONS.ENABLED,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      "mode",
      {
        function()
          return consts.ICONS.ENABLED and "󰯊 " or "S"
        end,
        cond = function()
          return state.spider_mappings
        end,
        padding = { left = 0, right = 1 },
      },
    },
    lualine_b = {
      { "branch", icon = "" },
      "diff",
      {
        "diagnostics",
        sections = { "error", "warn", "hint" },
        symbols = {
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
        icon = "󰒋",
        symbols = {
          spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
          done = "",
          separator = "|",
        },
      },
      { "filetype", icon = consts.ICONS.ENABLED, colored = true },
    },
    lualine_y = { "%l:%v" },
    lualine_z = { "%LL" },
  },
})
