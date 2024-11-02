local autocmd = vim.api.nvim_create_autocmd
local api = require("nvim-tree.api")
local keymap = vim.keymap.set
local consts = require("lib.consts")
local lib = require("lib.main")

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

  keymap("n", "%", api.fs.create, opts("Create"))
  keymap("n", "d", api.fs.create, opts("Create"))
  keymap("n", "y", api.fs.copy.node, opts("Copy"))
  keymap("n", "D", api.fs.trash, opts("Trash"))
  keymap("n", "R", api.fs.rename, opts("Rename"))
  keymap("n", "<C-S>", api.node.open.horizontal, opts("Open: Horizontal Split"))

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
  keymap({ "n", "v" }, "<C-K>", "<C-W>k", opts("go N windows up"))
  keymap({ "n", "v" }, "<C-J>", "<C-W>j", opts("go N windows down"))
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
  keymap("n", "<Space>m", api.tree.toggle_no_bookmark_filter, opts("Toggle Filter: No Bookmark"))

  keymap("n", "<Space>l", api.node.open.toggle_group_empty, opts("Toggle Filter: Group empty"))
end

require("nvim-tree").setup({
  on_attach = my_on_attach,
  hijack_cursor = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,
  sort_by = "case_sensitive",
  view = { adaptive_size = true, width = 10, signcolumn = "auto" },
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
      hint = consts.DIAGNOSTIC_SIGNS.hint,
      info = consts.DIAGNOSTIC_SIGNS.info,
      warning = consts.DIAGNOSTIC_SIGNS.warning,
      error = consts.DIAGNOSTIC_SIGNS.error,
    },
  },
  live_filter = { always_show_folders = false },
  actions = {
    change_dir = { restrict_above_cwd = true },
    open_file = { window_picker = { enable = false }, quit_on_open = true },
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
require("lsp-file-operations").setup()

local actions = require("aerial.actions")
local aerial = require("aerial")
local function close_restore_prev_pos()
  aerial.close()
  pcall(function()
    lib.norm("`m")
    vim.cmd.delmarks("m")
  end)
end
aerial.setup({
  layout = { default_direction = "prefer_left", max_width = { 28, 0.3 } },
  icons = { Collapsed = " >" },
  highlight_on_jump = false,
  attach_mode = "window",
  keymaps = {
    ["o"] = actions.jump,
    ["k"] = actions.prev,
    ["j"] = actions.next,
    ["K"] = actions.prev_up,
    ["J"] = actions.next_up,
    -- ["<C-K>"] = "<C-W>k",
    -- ["<C-J>"] = "<C-W>j",
    -- ["<C-K>"] = function()
    --   aerial.prev_up()
    --   aerial.next()
    -- end,
    -- ["<C-J>"] = function()
    --   aerial.next_up()
    --   aerial.prev()
    -- end,
    ["H"] = function()
      aerial.tree_close({ recurse = true })
    end,
    ["L"] = function()
      aerial.tree_open({ recurse = true })
    end,
    ["W"] = actions.tree_close_all,
    ["E"] = actions.tree_open_all,
    ["<C-P>"] = actions.prev_up,
    ["<C-O>"] = close_restore_prev_pos,
  },
  close_on_select = true,
  show_guides = true,
  guides = {
    -- When the child item has a sibling below it
    mid_item = "🭲 ",
    -- When the child item is the last in the list
    last_item = "🭲 ",
    -- When there are nested child guides to the right
    nested_top = "🭲 ",
    -- Raw indentation
    whitespace = "  ",
  },
  -- filter_kind = false,
  autojump = true,
})
keymap("n", "<Space>s", "mm:AerialOpen<CR>")
autocmd("FileType", {
  pattern = "aerial",
  callback = function()
    vim.opt_local.cursorlineopt = "line"
  end,
})
