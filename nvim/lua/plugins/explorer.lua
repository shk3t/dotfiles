local api = require("nvim-tree.api")

require("nvim-tree").setup({
  hijack_cursor = true,
  hijack_netrw = true,
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
      padding = "",
      symlink_arrow = " -> ",
      show = {file = false, folder = false, folder_arrow = true, git = false},
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
