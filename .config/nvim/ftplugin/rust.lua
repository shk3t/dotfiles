local ulib = require("lib.utils")

vim.keymap.set("n", "<C-CR>", function()
  ulib.norm(":wa<CR>")
  ulib.term("rustc " .. vim.fn.expand("%") .. [[ -o rust.out && ./rust.out && rm rust.out]])
end, { buffer = true })
