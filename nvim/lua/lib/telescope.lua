local M = {}

local builtin = require("telescope.builtin")
local consts = require("lib.consts")

M.paste_action = function(_)
  local selection = vim.fn.getreg("\"") or ""
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

M.adjust_iconpath_display = function(config, pickers, ext_pickers)
  pickers = pickers or {}
  ext_pickers = ext_pickers or {}
  if not consts.ICONS_ENABLED then return end
  local function adjusted_diplay(opts, path) return " " .. path end
  for _, picker in pairs(pickers) do config.pickers[picker].path_display = adjusted_diplay end
  for _, picker in pairs(ext_pickers) do config.extensions[picker].path_display = adjusted_diplay end
end

return M
