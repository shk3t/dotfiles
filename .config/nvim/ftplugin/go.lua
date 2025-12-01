local inputs = require("lib.base.input")
local lcfg = require("lib.localcfg")
local winbuf = require("lib.winbuf")

vim.keymap.set("n", "<C-CR>", function()
  inputs.norm(":wa<CR>")
  winbuf.term(lcfg.local_config_or({ "run", "go" }, "go run " .. vim.fn.expand("%")))
end, { buffer = true })
