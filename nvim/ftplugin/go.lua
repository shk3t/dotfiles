local keymap = vim.keymap.set

keymap("n", "<C-CR>", ":wa<CR>:exec '!go run' shellescape(@%, 1)<CR>", {
  buffer = true,
})
