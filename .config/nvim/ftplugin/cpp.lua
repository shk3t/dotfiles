vim.keymap.set(
  "n",
  "<C-CR>",
  ":wa<CR>:exec" .. " '!g++' shellescape(@%, 1) '-o cpp.out" .. " && ./cpp.out" .. " && rm cpp.out'<CR>",
  { buffer = true }
)
