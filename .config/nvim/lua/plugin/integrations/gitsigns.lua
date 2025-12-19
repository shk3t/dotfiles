local keymap = vim.keymap.set
local gitsigns = require("gitsigns")
local teleutils = require("util.telescope")

require("gitsigns").setup({
  signs = {
    add = { text = "█" },
    change = { text = "█" },
    delete = { text = "▄" },
    topdelete = { text = "▀" },
    changedelete = { text = "▐" },
    untracked = { text = "▚" },
  },
  signs_staged_enable = false,
  sign_priority = 6,
  update_debounce = 100,
  max_file_length = 40000,

  on_attach = function(bufnr)
    -- Navigation
    keymap("n", "]g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]g", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { buffer = true })
    keymap("n", "[g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[g", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { buffer = true })

    -- Actions
    keymap("n", "<Space>gr", gitsigns.reset_hunk, { buffer = true })
    keymap("x", "<Space>gr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { buffer = true })
    keymap("n", "<Space>GR", gitsigns.reset_buffer, { buffer = true })

    -- Info
    keymap("n", "<Space>gk", gitsigns.preview_hunk_inline, { buffer = true })
    keymap("n", "<Space>gh", function()
      gitsigns.setqflist(
        "all",
        {},
        teleutils.quickfix_picker("Git Hunks", function()
          return
        end)
      )
    end, { buffer = true })
    keymap("n", "<Space>gd", gitsigns.diffthis, { buffer = true })
    keymap("n", "<Space>gb", gitsigns.blame, { buffer = true })

    -- Text object
    keymap({ "o", "x" }, "ig", gitsigns.select_hunk, { buffer = true })
  end,
})
