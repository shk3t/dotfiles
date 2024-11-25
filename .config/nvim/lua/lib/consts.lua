local M = {}

M.PRESERVE_MARK = "m"
M.TRANSPARENCY = 0  -- 15
M.VERTICAL_BORDERS = {"", "", "", " ", "", "", "", " "}
M.DIAGNOSTIC_SIGNS = {error = "󰚌", warn = "󰐼", hint = "󰌵", info = ""}
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
  Tabby = "󰄛",
}

return M
