-- DRY < KISS
local merge_lists = function(...)
  local result = {}
  for _, tbl in pairs({ ... }) do
    vim.list_extend(result, tbl)
  end
  return result
end

local DAP = {
  FILETYPES = { "dap-repl", "dapui_stacks", "dapui_scopes", "dapui_watches" },
  FILENAMES = { "DAP Stacks", "DAP Scopes", "DAP Watches" },
  RUNTIME_THREADS = { "runtime" },
  REPL_FILENAME_PATTERN = "%[dap%-repl%-%d+%]",
}
local DB = {
  FILENAMES = { "dbui", "dbout" },
}

return {
  -- Plugins
  DAP = DAP,
  DB = DB,

  -- Navigation
  AUXILIARY_BUF = {
    FILENAMES = merge_lists(DAP.FILENAMES, DB.FILENAMES, { "null", "ui", "DiffviewFilePanel" }),
  },
  PRESERVE_MARK = "m",

  -- Appearance
  COLORSCHEME = "rose-pine",
  TRANSPARENCY = 0, -- 15
  ICONS = {
    ENABLED = true,
    CMP_KIND = {
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
    },
    DIAGNOSTIC = { error = "󰚌", warn = "󰐼", hint = "󰌵", info = "" },
    BORDER = { "", "", "", " ", "", "", "", " " },
  },

  -- System
  SYSTEM = {
    IS_KDE = true,
    IS_XDOTOOL_AVAILABLE = false,
  },
  LAYOUT = { ENGLISH_IDX = 0 },
  FILETYPE_PRIORITIES = { directory = 1, file = 2, link = -1 },

  -- Files
  LOCAL_CONFIG_FILENAME = "nvim.lua",
  DEFAULT_PYTHON_PATH = "/usr/bin/python",
}
