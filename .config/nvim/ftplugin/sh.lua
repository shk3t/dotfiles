vim.keymap.set("n", "<C-CR>", ":wa<CR>:exec '!bash' shellescape(@%, 1)<CR>", { buffer = true })
