local api = require("nvim-tree.api")
local keymap = vim.keymap.set

local function my_on_attach(bufnr)
  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  api.config.mappings.default_on_attach(bufnr)

  keymap("n", "%", api.fs.rename, opts("Create"))
  keymap("n", "d", api.fs.rename, opts("Create"))
  keymap("n", "y", api.fs.copy.node, opts("Copy"))
  keymap("n", "D", api.fs.trash, opts("Trash"))
  keymap("n", "R", api.fs.rename, opts("Rename"))
end

require("nvim-tree").setup({
  on_attach = my_on_attach,
  hijack_cursor = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,
  sort_by = "case_sensitive",
  view = {adaptive_size = true, width = 10, signcolumn = "no"},
  renderer = {
    root_folder_label = false,
    indent_markers = {
      enable = true,
      inline_arrows = false,
      icons = {
        corner = "⎹",
        edge = "⎹",
        item = "⎹",
        bottom = "⎹",
        none = " ",
      },
    },
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
  layout = {default_direction = "prefer_left", max_width = {28, 0.3}},
  icons = {Collapsed = " >"},
  highlight_on_jump = false,
  attach_mode = "window",
  keymaps = {["h"] = false, ["l"] = false},
  close_on_select = true,
  show_guides = true,
  guides = {
    -- When the child item has a sibling below it
    mid_item = "⎹ ",
    -- When the child item is the last in the list
    last_item = "⎹ ",
    -- When there are nested child guides to the right
    nested_top = "⎹ ",
    -- Raw indentation
    whitespace = "  ",
  },
  -- filter_kind = false,
})
keymap("n", "gs", vim.cmd.AerialOpen)
