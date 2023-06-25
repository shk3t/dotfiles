vim.keymap.set("n", "<Space>E", "<Cmd>NvimTreeFindFile<CR>")

require("nvim-tree").setup({
  hijack_cursor = true,
  hijack_netrw = false,
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    width = 10,
    signcolumn = "no",
    mappings = {
      list = {
        {key = "l", action = "edit"},
        {key = "h", action = "close_node"},
        {key = "R", action = "rename"},
        {key = "%", action = "create"},
        {key = "d", action = "create"},
        {key = "D", action = "trash"},
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
    open_file = {window_picker = {enable = false}},
  },
  notify = {threshold = vim.log.levels.ERROR},
})
