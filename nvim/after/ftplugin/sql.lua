vim.keymap.set("n", "<C-CR>", ":wa<CR>:exec '!psql -f' shellescape(@%, 1)<CR>", {
  buffer = true,
})