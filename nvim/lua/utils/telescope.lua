local M = {}

local builtin = require("telescope.builtin")

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
