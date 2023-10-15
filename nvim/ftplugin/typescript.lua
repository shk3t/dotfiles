vim.keymap.set("n", "<C-CR>", ":wa<CR>:exec '!ts-node' shellescape(@%, 1)<CR>")
