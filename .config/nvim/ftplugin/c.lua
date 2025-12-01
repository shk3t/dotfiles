if vim.bo.filetype ~= "c" then
  return
end

vim.keymap.set(
  "n",
  "<C-CR>",
  ":wa<CR>:exec" .. " '!gcc -lm' shellescape(@%, 1) '-o c.out" .. " && ./c.out" .. " && rm c.out'<CR>",
  { buffer = true }
)

vim.keymap.set("n", "<Space>D", ":wa<CR>:exec" .. " '!gcc -lm -g' shellescape(@%, 1) '-o c.out'<CR>", { buffer = true })
