vim.keymap.set("n", "<C-CR>", ":wa<CR>:exec '!lua' shellescape(@%, 1)<CR>", { buffer = true })
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
