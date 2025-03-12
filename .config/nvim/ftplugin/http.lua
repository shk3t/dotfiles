local keymap = vim.keymap.set
local kulala = require("kulala")

keymap("n", "<C-CR>", kulala.run, { buffer = true, desc = "Send request" })
keymap("n", "<Space>rs", kulala.run, { buffer = true, desc = "Send request" })
keymap("n", "<Space>ra", kulala.run_all, { buffer = true, desc = "Send all requests" })
keymap("n", "<Space>rr", kulala.replay, { buffer = true, desc = "Replay the last request" })
