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
  cache = {},
  local_config = {},
  dap = {
    widgets = {
      scopes = nil,
    },
    focus = {
      thread = {
        id = nil,
        name = nil,
      },
    },
  },
}
