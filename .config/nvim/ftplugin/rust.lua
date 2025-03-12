local lib = require("lib.main")

vim.keymap.set("n", "<C-CR>", function()
  lib.norm(":wa<CR>")
  lib.term("rustc " .. vim.fn.expand("%") .. [[ -o rust.out && ./rust.out && rm rust.out]])
end, { buffer = true })
