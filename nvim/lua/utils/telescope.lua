local M = {}

local builtin = require("telescope.builtin")

local function paste_action(_)
  local selection = vim.fn.getreg("\"")
  if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
    vim.api.nvim_paste(selection, true, -1)
  end
end
M.paste_action = paste_action

local function custom_quickfix_picker(title, callback)
  return function()
    if not pcall(function() callback() end) then return end
    local win_id = vim.fn.win_getid()
    builtin.quickfix({prompt_title = title})
    vim.api.nvim_win_close(win_id, false)
  end
end
M.custom_quickfix_picker = custom_quickfix_picker

return M
