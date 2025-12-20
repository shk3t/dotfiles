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
  MASON_ENSURE_INSTALLED = true,

  -- Navigation
  AUXILIARY_BUF = {
    FILENAMES = merge_lists(DAP.FILENAMES, DB.FILENAMES, { "null", "ui", "DiffviewFilePanel" }),
  },

  -- Appearance
  COLORSCHEME = "rose-pine",
  TRANSPARENCY = 0, -- 15
  ICONS = {
    ENABLED = true,
    DIAGNOSTIC = { ERROR = "󰚌", WARN = "󰐼", HINT = "󰌵", INFO = "" },
    BORDER = { "", "", "", " ", "", "", "", " " },
    ALT_BORDER = { " ", " ", " ", " ", " ", " ", " ", " " },
    GUIDE = "▎",
    KINDS = {
      Array = " ",
      Boolean = "󰨙 ",
      Class = " ",
      Codeium = "󰘦 ",
      Color = " ",
      Control = " ",
      Collapsed = " ",
      Constant = "󰏿 ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = "󰊕 ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = "󰊕 ",
      Module = " ",
      Namespace = "󰦮 ",
      Null = " ",
      Number = "󰎠 ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = "󱄽 ",
      String = " ",
      Struct = "󰆼 ",
      Supermaven = " ",
      TabNine = "󰏚 ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = "󰀫 ",
    },
  },

  -- System
  SYSTEM = {
    IS_KDE = true,
    IS_XDOTOOL_AVAILABLE = false,
  },
  LAYOUT = { ENGLISH_IDX = 0 },
  FILETYPE_PRIORITIES = { directory = 1, file = 2, link = -1 },

  -- Files
  NVIM_ETC = vim.fn.stdpath("config") .. "/etc",
  MASON = {
    PACKAGES = vim.fn.stdpath("data") .. "/mason/packages",
    BIN = vim.fn.stdpath("data") .. "/mason/bin",
  },
  LOCAL_CONFIG_FILENAME = "nvim.lua",
  DEFAULT_PYTHON_PATH = "/usr/bin/python",
}
