local inputs = require("lib.base.input")
local winbuf = require("lib.winbuf")

vim.keymap.set("n", "<C-CR>", function()
  inputs.norm(":wa<CR>")
  winbuf.term("rustc " .. vim.fn.expand("%") .. [[ -o rust.out && ./rust.out && rm rust.out]])
end, { buffer = true })
