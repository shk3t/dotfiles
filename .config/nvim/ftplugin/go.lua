local ulib = require("lib.utils")

vim.keymap.set("n", "<C-CR>", function()
  ulib.norm(":wa<CR>")
  ulib.term(ulib.local_config_or({ "run", "go" }, "go run " .. vim.fn.expand("%")))
end, { buffer = true })
