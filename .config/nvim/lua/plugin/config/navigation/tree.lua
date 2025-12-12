local keymap = vim.keymap.set
local api = require("nvim-tree.api")
local consts = require("consts")
local utils = require("plugin.util.tree")

local function custom_attach(bufnr)
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

  keymap("n", "%", api.fs.create, opts("Create"))
  keymap("n", "d", api.fs.create, opts("Create"))
  keymap("n", "y", api.fs.copy.node, opts("Copy"))
  keymap("n", "D", api.fs.trash, opts("Trash"))
  keymap("n", "R", api.fs.rename_full, opts("Rename"))
  keymap("n", "<C-S>", api.node.open.horizontal, opts("Open: Horizontal Split"))

  keymap("n", "b", api.marks.toggle, opts("Toggle Bookmark"))
  keymap("n", "BD", api.marks.bulk.trash, opts("Trash Bookmarked"))
  keymap("n", "BR", api.marks.bulk.move, opts("Move Bookmarked"))

  keymap("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
  keymap("n", "l", api.node.open.preview, opts("Open Preview"))
  keymap("n", "H", api.tree.collapse_all, opts("Collapse"))
  keymap("n", "L", api.tree.expand_all, opts("Expand All"))
  keymap("n", "K", api.node.navigate.sibling.prev, opts("Previous Sibling"))
  keymap("n", "J", api.node.navigate.sibling.next, opts("Next Sibling"))
  -- keymap("n", "<C-K>", api.node.navigate.sibling.first, opts("FirstSibling"))
  -- keymap("n", "<C-J>", api.node.navigate.sibling.last, opts("Last Sibling"))
  vim.keymap.del("n", "<C-K>", { buffer = bufnr })
  keymap("n", "<C-P>", api.node.navigate.parent, opts("Parent directory"))

  keymap("n", "gk", api.node.show_info_popup, opts("Info"))
  keymap("n", "O", api.node.open.preview, opts("Open Preview"))
  keymap("n", "<S-CR>", api.node.open.preview, opts("Open Preview"))

  keymap("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
  keymap("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
  keymap("n", "[g", api.node.navigate.git.prev, opts("Prev Git"))
  keymap("n", "]g", api.node.navigate.git.next, opts("Next Git"))

  keymap("n", "<Space>b", api.tree.toggle_no_buffer_filter, opts("Toggle Filter: No Buffer"))
  keymap("n", "<Space>g", api.tree.toggle_git_clean_filter, opts("Toggle Filter: Git Clean"))
  keymap("n", "<Space>h", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
  keymap("n", "<Space>i", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git ignore"))
  keymap("n", "<Space>B", api.tree.toggle_no_bookmark_filter, opts("Toggle Filter: No Bookmark"))

  keymap("n", "<Space>l", api.node.open.toggle_group_empty, opts("Toggle Filter: Group empty"))
end

require("nvim-tree").setup({
  on_attach = custom_attach,
  hijack_cursor = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,
  sort_by = function(nodes)
    table.sort(nodes, utils.natural_order_with_filetype_cmp)
  end,

  view = {
    preserve_window_proportions = false,
    adaptive_size = true,
    width = 10,
    signcolumn = "auto",
  },
  renderer = {
    root_folder_label = false,
    indent_markers = {
      enable = true,
      inline_arrows = false,
      icons = {
        corner = "🭲",
        edge = "🭲",
        item = "🭲",
        bottom = "🭲",
        none = " ",
      },
    },
    group_empty = false,
    icons = {
      git_placement = "signcolumn",
      diagnostics_placement = "right_align",
      bookmarks_placement = "right_align",
      padding = "  ",
      symlink_arrow = " -> ",
      show = {
        file = true,
        folder = true,
        folder_arrow = false,
        git = true,
        diagnostics = true,
        bookmarks = true,
      },
      glyphs = {
        symlink = "",
        folder = { arrow_closed = ">", arrow_open = "v" },
        git = {
          unstaged = "",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "",
          deleted = "",
          ignored = "",
        },
      },
    },
  },
  filters = {
    git_ignored = false,
    dotfiles = false,
  },
  git = {
    enable = true,
    show_on_open_dirs = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    severity = {
      min = vim.diagnostic.severity.ERROR,
      max = vim.diagnostic.severity.ERROR,
    },
    icons = {
      hint = consts.ICONS.DIAGNOSTIC.HINT,
      info = consts.ICONS.DIAGNOSTIC.INFO,
      warning = consts.ICONS.DIAGNOSTIC.warning,
      error = consts.ICONS.DIAGNOSTIC.ERROR,
    },
  },
  live_filter = { always_show_folders = false },
  actions = {
    change_dir = { restrict_above_cwd = true },
    open_file = {
      window_picker = { enable = false },
      quit_on_open = true,
    },
  },
  notify = { threshold = vim.log.levels.ERROR },
  ui = {
    confirm = {
      remove = true,
      trash = true,
      default_yes = true,
    },
  },
})

vim.keymap.set("n", "<Space>e", vim.cmd.NvimTreeFindFile)
