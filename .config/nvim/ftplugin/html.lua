vim.keymap.set("n", "<C-CR>", ":wa<CR>:exec '!google-chrome-stable' shellescape(@%, 1)<CR>", { buffer = true })
