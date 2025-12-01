local keymap = vim.keymap.set

keymap("n", "<C-O>", ":Rexplore<CR>", {buffer = true, silent = true})
keymap("n", "<C-^>", ":Rexplore<CR>", {buffer = true, silent = true})
keymap("n", "<C-L>", [[<Cmd>lua require("tmux").move_right()<CR>]], {buffer = true, silent = true})
