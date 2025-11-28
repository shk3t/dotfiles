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
vim.keymap.set({ "n", "v" }, "<Space>GD", vim.cmd.DiffviewOpen)
