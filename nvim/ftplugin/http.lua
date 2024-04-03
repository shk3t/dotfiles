local keymap = vim.keymap.set

keymap("n", "<C-CR>", ":wa<CR>mm:Rest run<CR>", { buffer = true })
