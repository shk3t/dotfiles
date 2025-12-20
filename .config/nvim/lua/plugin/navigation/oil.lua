local keymap = vim.keymap.set
local consts = require("consts")
local inputs = require("lib.base.input")
local oil = require("oil")

require("oil").setup({
  default_file_explorer = true,
  columns = {
    "icon",
  },
  win_options = {
    cursorlineopt = "line,number",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
  prompt_save_on_select_new_entry = true,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 8000,
    autosave_changes = false,
  },
  watch_for_changes = true,
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["q"] = { "actions.close", mode = "n" },
    ["<C-Q>"] = { "actions.close", mode = "n" },
    ["-"] = { "actions.parent", mode = "n" },
    ["_"] = { "actions.open_cwd", mode = "n" },
    ["`"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["g<CR>"] = "actions.open_external",
    ["g<Del>"] = { "actions.toggle_trash", mode = "n" },
  },
  use_default_keymaps = false,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, bufnr)
      return name == ".."
    end,
    natural_order = "fast",
    case_insensitive = false,
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  confirmation = {
    width = 0.3,
    height = 0.3,
    border = consts.ICONS.ALT_BORDER,
  },
})

keymap("n", "<Space>e", function()
  oil.open(nil, nil, function()
    oil.open_preview(nil, function()
      inputs.norm("<C-W>H80<C-W>|")
    end)
  end)
end)
