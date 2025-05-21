local keymap = vim.keymap.set
local kulala = require("kulala")
local kulala_ui = require("kulala.ui")

kulala.setup({
  ui = {
    default_view = "headers_body",
    default_winbar_panes = {
      "headers_body",
      "verbose",
      "script_output",
      "report",
      "stats",
    },
    icons = {
      inlay = {
        loading = "󰔟 ",
        done = "󰩐 ",
        error = "󰯇 ",
      },
    },
  },
  kulala_keymaps = {
    ["Show body"] = false,
    ["Show headers"] = false,
    ["Show all"] = { "1", kulala_ui.show_headers_body },
    ["Show verbose"] = { "2", kulala_ui.show_verbose },
    ["Show script output"] = { "3", kulala_ui.show_script_output },
    ["Show report"] = { "4", kulala_ui.show_report },
    ["Show stats"] = { "5", kulala_ui.show_stats },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    keymap("n", "<C-CR>", kulala.run, { buffer = true, desc = "Send request" })
    keymap("n", "<Space>rs", kulala.run, { buffer = true, desc = "Send request" })
    keymap("n", "<Space>ra", kulala.run_all, { buffer = true, desc = "Send all requests" })
    keymap("n", "<Space>rr", kulala.replay, { buffer = true, desc = "Replay the last request" })
  end,
})
