vim.keymap.set("n", "<C-O>", ":Rexplore<CR>", {buffer = true, silent = true})
vim.keymap.set("n", "<C-^>", ":Rexplore<CR>", {buffer = true, silent = true})
vim.keymap.set("n", "<C-L>", [[<Cmd>lua require("tmux").move_right()<CR>]], {buffer = true, silent = true})
