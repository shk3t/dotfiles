local DAP = {
  RUNTIME_THREADS = { "runtime" },
  FILETYPES = { "dap-repl", "dapui_stacks", "dapui_scopes", "dapui_watches" },
  FILENAMES = { "DAP Stacks", "DAP Scopes", "DAP Watches" },
  REPL_FILENAME_PATTERN = "%[dap%-repl%-%d+%]",
}
local DB = {
  FILENAMES = { "dbui", "dbout" },
}
local HTTP = {
  FILENAMES = { "ui" },
}

return {
  LOCAL_CONFIG_FILE = "nvim.lua",
  FILETYPE_PRIORITIES = { directory = 1, file = 2, link = -1 },
  COLORSCHEME = "rose-pine",
  PRESERVE_MARK = "m",
  TRANSPARENCY = 0, -- 15
  VERTICAL_BORDERS = { "", "", "", " ", "", "", "", " " },
  DIAGNOSTIC_SIGNS = { error = "󰚌", warn = "󰐼", hint = "󰌵", info = "" },
  ICONS_ENABLED = true,
  CMP_KIND_ICONS = {
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
  },
  DAP = DAP,
  DB = DB,
  HTTP = HTTP,
  AUXILIARY = {
    FILENAMES = vim.tbl_extend("keep", DAP.FILENAMES, DB.FILENAMES, HTTP.FILENAMES),
  },
  DEFAULT_PYTHON_PATH = "/usr/bin/python",
}
