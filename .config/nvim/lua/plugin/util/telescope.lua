local consts = require("consts")
local cmds = require("lib.cmds")
local builtin = require("telescope.builtin")

local M = {}

function M.quickfix_picker(title, callback)
  return function()
    if not pcall(callback) then
      return
    end
    local cur_win = vim.api.nvim_get_current_win()
    builtin.quickfix({ prompt_title = title })
    vim.api.nvim_win_close(cur_win, false)
  end
end

function M.visual_picker(picker)
  return function()
    local visual = cmds.get_visual()
    picker({ default_text = visual })
  end
end

function M.cword_picker(picker)
  return function()
    local word_under_cursor = vim.fn.expand("<cword>")
    picker({ default_text = word_under_cursor })
  end
end

function M.paste_action()
  local selection = vim.fn.getreg('"') or ""
  if vim.bo.modifiable then
    vim.api.nvim_paste(selection, true, -1)
  end
end

function M.adjust_iconpath_display(config, pickers, ext_pickers)
  pickers = pickers or {}
  ext_pickers = ext_pickers or {}
  if not consts.ICONS.ENABLED then
    return
  end
  local function adjusted_diplay(opts, path)
    return " " .. path
  end
  for _, picker in pairs(pickers) do
    config.pickers[picker].path_display = adjusted_diplay
  end
  for _, picker in pairs(ext_pickers) do
    config.extensions[picker].path_display = adjusted_diplay
  end
end

return M
