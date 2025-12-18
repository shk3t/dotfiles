local keymap = vim.keymap.set
local inputs = require("lib.base.input")
local lcfg = require("lib.localcfg")
local winbuf = require("lib.winbuf")

keymap("n", "<C-CR>", function()
  inputs.norm(":wa<CR>")
  winbuf.term(lcfg.local_config_or({ "run", "python" }, "python " .. vim.fn.expand("%")))
end, { buffer = true })

keymap("n", "gcd", function()
  local ignore_comment = "  # type: ignore"
  local line = vim.api.nvim_get_current_line()
  if line:find(ignore_comment) then
    line = line:gsub(ignore_comment, "", 1)
  else
    line = line .. ignore_comment
  end
  vim.api.nvim_set_current_line(line)
end, { buffer = true })
