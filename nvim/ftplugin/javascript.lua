vim.keymap.set("n", "<C-CR>", ":wa<CR>:exec '!node' shellescape(@%, 1)<CR>")
