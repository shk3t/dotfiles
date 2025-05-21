local autocmd = vim.api.nvim_create_autocmd
local telelib = require("lib.telescope")

local keymap = vim.keymap.set

require("gitsigns").setup({
  signs = {
    add = { text = "█" },
    change = { text = "█" },
    delete = { text = "▄" },
    topdelete = { text = "▀" },
    changedelete = { text = "▐" },
    untracked = { text = "▚" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = { follow_files = true },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 0,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d>: <summary> (<abbrev_sha>)",
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

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function bufmap(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      keymap(mode, l, r, opts)
    end

    -- Navigation
    bufmap("n", "]g", function()
      if vim.wo.diff then
        return "]g"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    bufmap("n", "[g", function()
      if vim.wo.diff then
        return "[g"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- Actions
    bufmap("n", "<Space>ga", gs.stage_hunk)
    bufmap("v", "<Space>ga", function()
      gs.stage_hunk({
        vim.fn.line("."),
        vim.fn.line("v"),
      })
    end)
    bufmap("n", "<Space>gu", gs.undo_stage_hunk)
    bufmap("n", "<Space>gr", gs.reset_hunk)
    bufmap("v", "<Space>gr", function()
      gs.reset_hunk({
        vim.fn.line("."),
        vim.fn.line("v"),
      })
    end)
    bufmap("n", "<Space>gk", gs.preview_hunk)
    keymap("n", "<Space>gh", function()
      gs.setqflist(
        "all",
        {},
        telelib.quickfix_picker("Git Hunks", function()
          return
        end)
      )
    end)

    bufmap("n", "<Space>GA", gs.stage_buffer)
    bufmap("n", "<Space>GR", gs.reset_buffer)
    -- bufmap("n", "<Space>GB", gs.toggle_current_line_blame)
    bufmap("n", "<Space>GP", gs.toggle_deleted)

    -- Text object
    bufmap({ "o", "v" }, "ig", ":<C-U>Gitsigns select_hunk<CR>")
    bufmap({ "o", "v" }, "ag", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})

require("blame").setup({ width = 35, date_format = "%H:%M %d.%m.%Y" })
keymap("n", "<Space>GB", vim.cmd.BlameToggle)
autocmd("FileType", {
  pattern = "blame",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.wrap = false
    vim.opt_local.cursorlineopt = "line"
  end,
})

local actions = require("diffview.actions")
require("diffview").setup({
  use_icons = false,
  signs = { fold_closed = "> ", fold_open = "v ", done = "√" },
  keymaps = {
    file_panel = {
      ["a"] = actions.toggle_stage_entry,
      ["x"] = actions.toggle_stage_entry,
    },
  },
})
keymap({ "n", "v" }, "<Space>GD", vim.cmd.DiffviewOpen)
