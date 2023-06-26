local keymap = vim.keymap.set

keymap("n", "<C-CR>", ":wa<CR>:exec '!python3' shellescape(@%, 1)<CR>", {
  buffer = true,
})
keymap("n", "<Space>MI", ":MagmaInit python3<CR>", {buffer = true})
