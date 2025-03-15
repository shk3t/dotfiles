local lib = require("lib.main")

vim.keymap.set("n", "<C-CR>", function()
  lib.norm(":wa<CR>")
  lib.term(lib.local_config_or({ "run", "go" }, "go run " .. vim.fn.expand("%")))
end, { buffer = true })
