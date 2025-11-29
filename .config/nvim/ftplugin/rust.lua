local inputs = require("lib.base.input")

vim.keymap.set("n", "<C-CR>", function()
  inputs.norm(":wa<CR>")
  inputs.term("rustc " .. vim.fn.expand("%") .. [[ -o rust.out && ./rust.out && rm rust.out]])
end, { buffer = true })
