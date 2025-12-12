vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

vim.keymap.set("n", "<C-CR>", ":wa<CR>:exec '!lua' shellescape(@%, 1)<CR>", { buffer = true })
