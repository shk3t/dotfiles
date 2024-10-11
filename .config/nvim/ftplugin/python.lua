local keymap = vim.keymap.set
local lib = require("lib.main")

vim.g.no_python_maps = true

keymap("n", "<C-CR>", ":wa<CR>:exec '!python3' shellescape(@%, 1)<CR>", {
  buffer = true,
})
keymap("n", "<Space>JI", ":MagmaInit python3<CR>", {buffer = true})
keymap("n", "gct", function()
  local ignore_comment = "  # type: ignore"
  local current_line = vim.api.nvim_get_current_line()
  if current_line:find(ignore_comment) then
    current_line = current_line:gsub(ignore_comment, "")
  else
    current_line = current_line .. ignore_comment
  end
  vim.api.nvim_set_current_line(current_line)
end, {buffer = true})

-- Jupyter integration
-- keymap({ "n", "v" }, "<F5>", vim.cmd.MoltenOpenInBrowser, { buffer = true })
