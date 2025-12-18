local keymap = vim.keymap.set
local inputs = require("lib.base.input")

keymap("n", "<F5>", vim.cmd.MarkdownPreviewToggle, { buffer = true })

keymap("n", "gx", function()
  local line = vim.api.nvim_get_current_line()
  if line:find("%[ %]") then
    line = line:gsub("%[ %]", "[X]", 1)
  elseif line:find("%[X%]") then
    line = line:gsub("%[X%]", "[ ]", 1)
  end
  vim.api.nvim_set_current_line(line)
end, { buffer = true })

keymap("x", "gx", function()
  inputs.norm("<Esc>")
  local sl = vim.fn.line("'<")
  local el = vim.fn.line("'>")

  local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)

  local tick = false
  for _, line in pairs(lines) do
    if line:find("%[ %]") then
      tick = true
      break
    end
  end

  for i, line in pairs(lines) do
    if tick then
      lines[i] = line:gsub("%[ %]", "[X]", 1)
    else
      lines[i] = line:gsub("%[X%]", "[ ]", 1)
    end
  end

  vim.api.nvim_buf_set_lines(0, sl - 1, el, false, lines)
end, { buffer = true })
