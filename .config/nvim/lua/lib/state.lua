return {
  main_term = {
    buf = -1,
    win = -1,
    mode = "t",
  },
  system = {
    terminal_window_id = vim.fn.system([[xdotool getactivewindow]]),
    tmux_window_id = vim.fn.system([[tmux display-message -p "#I"]]),
  },
  cache = {
    backward_file_search = {},
    local_config = {},  -- TODO: load all config
  },
}
