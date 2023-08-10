local M = {}

local builtin = require("telescope.builtin")

M.paste_action = function(_)
  local selection = vim.fn.getreg("\"")
  if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
    vim.api.nvim_paste(selection, true, -1)
  end
end

M.custom_quickfix_picker = function(title, callback)
  return function()
    if not pcall(function() callback() end) then return end
    local cur_win = vim.api.nvim_get_current_win()
    builtin.quickfix({prompt_title = title})
    vim.api.nvim_win_close(cur_win, false)
  end
end

return M
