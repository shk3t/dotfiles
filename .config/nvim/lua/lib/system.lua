local M = {}

local setup = {
  is_kde = true,
  is_xdotool_available = false,
}

M.get_layout = function()
  if setup.is_kde then
    return tonumber(vim.fn.system([[qdbus org.kde.keyboard /Layouts org.kde.KeyboardLayouts.getLayout]]))
  end
end

M.set_layout = function(idx)
  if setup.is_kde then
    vim.fn.system([[qdbus org.kde.keyboard /Layouts org.kde.KeyboardLayouts.setLayout ]] .. tostring(idx))
  end
end

M.get_terminal_window = function()
  if setup.is_xdotool_available then
    return tonumber(vim.fn.system([[xdotool getactivewindow]]))
  end
  return -1
end

M.focus_window = function(window_id)
  if setup.is_xdotool_available then
    vim.fn.system("xdotool windowactivate " .. tostring(window_id))
  end
end

M.get_tmux_window = function()
  return tonumber(vim.fn.system([[tmux display-message -p "#I"]]))
end

M.focus_tmux_window = function(window_id)
  vim.fn.system("[[ $TMUX ]] && tmux select-window -t " .. tostring(window_id))
end

return M
