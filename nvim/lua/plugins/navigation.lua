local api = require("nvim-tree.api")
local keymap = vim.keymap.set

require("nvim-tree").setup({
  hijack_cursor = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    width = 10,
    signcolumn = "no",
    mappings = {
      list = {
        {key = "l", action = "edit"},
        {key = "h", action = "close_node"},
        {key = {"r", "R"}, action = "rename"},
        {key = {"%", "a", "d"}, action = "create"},
        {key = "D", action = "trash"},
        {key = {"c", "y"}, action = "copy"},
      },
    },
  },
  renderer = {
    root_folder_label = false,
    group_empty = false,
    icons = {
      padding = "  ",
      symlink_arrow = " -> ",
      show = {file = true, folder = true, folder_arrow = false, git = false},
      glyphs = {folder = {arrow_closed = ">", arrow_open = "v"}, symlink = ""},
    },
  },
  filters = {dotfiles = false},
  git = {enable = false},
  actions = {
    change_dir = {restrict_above_cwd = true},
    open_file = {window_picker = {enable = false}, quit_on_open = true},
  },
  notify = {threshold = vim.log.levels.ERROR},
})
require("lsp-file-operations").setup()

require("aerial").setup({
  layout = {default_direction = "prefer_left", max_width = {25, 0.3}},
  icons = {Collapsed = " >"},
  highlight_on_jump = false,
  attach_mode = "window",
  close_on_select = true,
  -- filter_kind = false,
})
keymap("n", "gs", vim.cmd.AerialOpen)