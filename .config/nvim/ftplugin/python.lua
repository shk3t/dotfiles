local keymap = vim.keymap.set
local inputs = require("lib.base.input")
local lcfg = require("lib.localcfg")
local winbuf = require("lib.winbuf")

vim.g.no_python_maps = true

keymap("n", "<C-CR>", function()
  inputs.norm(":wa<CR>")
  winbuf.term(lcfg.local_config_or({ "run", "python" }, "python " .. vim.fn.expand("%")))
end, { buffer = true })

keymap("n", "gct", function()
  local ignore_comment = "  # type: ignore"
  local current_line = vim.api.nvim_get_current_line()
  if current_line:find(ignore_comment) then
    current_line = current_line:gsub(ignore_comment, "")
  else
    current_line = current_line .. ignore_comment
  end
  vim.api.nvim_set_current_line(current_line)
end, { buffer = true })
