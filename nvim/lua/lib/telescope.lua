local M = {}

local builtin = require("telescope.builtin")
local consts = require("lib.consts")

M.paste_action = function(_)
  local selection = vim.fn.getreg("\"") or ""
  if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "modifiable") then
    vim.api.nvim_paste(selection, true, -1)
  end
end

M.get_visual_selection = function()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

M.quickfix_picker = function(title, callback)
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

M.visual_picker = function(picker)
  return function()
    local visual = M.get_visual_selection()
    local text = visual[1] or ""
    picker({default_text = text})
  end
end

M.cword_picker = function(picker)
  return function()
    local word_under_cursor = vim.fn.expand("<cword>")
    picker({default_text = word_under_cursor})
  end
end

return M
