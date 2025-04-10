local M = {}

M.LOCAL_CONFIG_FILE = "nvim.lua"
M.FILETYPE_PRIORITIES = { directory = 1, file = 2, link = -1 }
M.COLORSCHEME = "rose-pine"
M.PRESERVE_MARK = "m"
M.TRANSPARENCY = 0 -- 15
M.VERTICAL_BORDERS = { "", "", "", " ", "", "", "", " " }
M.DIAGNOSTIC_SIGNS = { error = "󰚌", warn = "󰐼", hint = "󰌵", info = "" }
M.ICONS_ENABLED = true
M.CMP_KIND_ICONS = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
  Database = "󰆼",
  Codeium = "󰘦",
}
M.DAP = {
  FILETYPES = { "dap-repl", "dapui_stacks", "dapui_scopes", "dapui_watches" },
  FILENAMES = { "DAP Stacks", "DAP Scopes", "DAP Watches" },
  REPL_FILENAME_PATTERN = "%[dap%-repl%-%d+%]",
}
M.DB = {
  FILENAMES = { "dbui", "dbout" },
}
M.HTTP = {
  FILENAMES = { "ui" },
}
M.AUXILIARY = {
  FILENAMES = vim.tbl_extend("force", M.DAP.FILENAMES, M.DB.FILENAMES, M.HTTP.FILENAMES),
}

return M
