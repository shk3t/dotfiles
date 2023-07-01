require("gitsigns").setup {
  signs = {
    add = {text = "█"},
    change = {text = "█"},
    delete = {text = "▄"},
    topdelete = {text = "▀"},
    changedelete = {text = "~"},
    untracked = {text = "┆"},
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {interval = 1000, follow_files = true},
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = "none",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {enable = false},

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function bufmap(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    bufmap("n", "]h", function()
      if vim.wo.diff then
        return "]h"
      end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, {expr = true})

    bufmap("n", "[h", function()
      if vim.wo.diff then
        return "[h"
      end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, {expr = true})

    -- Actions
    -- bufmap({"n", "v"}, "<Space>gs", ":Gitsigns stage_hunk<CR>")
    bufmap({"n", "v"}, "<Space>gr", ":Gitsigns reset_hunk<CR>")
    -- bufmap("n", "<Space>gS", gs.stage_buffer)
    -- bufmap("n", "<Space>gu", gs.undo_stage_hunk)
    bufmap("n", "<Space>GR", gs.reset_buffer)
    bufmap("n", "<Space>gk", gs.preview_hunk)
    -- bufmap("n", "<Space>gb", function() gs.blame_line {full = true} end)
    bufmap("n", "<Space>GB", gs.toggle_current_line_blame)
    bufmap("n", "<Space>gp", gs.diffthis)
    -- bufmap("n", "<Space>gD", function() gs.diffthis("~") end)
    -- bufmap("n", "<Space>GD", gs.toggle_deleted)

    -- Text object
    bufmap({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
}

local actions = require("diffview.actions")
require("diffview").setup({
  use_icons = false,
  signs = {
    fold_closed = ">",
    fold_open = "v",
    done = "√",
  },
})
