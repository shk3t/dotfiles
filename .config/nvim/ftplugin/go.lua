local inputs = require("lib.base.input")

vim.keymap.set("n", "<C-CR>", function()
  inputs.norm(":wa<CR>")
  inputs.term(inputs.local_config_or({ "run", "go" }, "go run " .. vim.fn.expand("%")))  -- TODO: it runs every time
end, { buffer = true })  -- TODO: remove all FileType autocmds where it is possible
