local syslib = require("lib.system")

return {
  main_term = {
    buf = -1,
    win = -1,
    mode = "t",
  },
  system = {
    terminal_window_id = syslib.get_terminal_window(),
    tmux_window_id = syslib.get_tmux_window(),
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
  insert_layout_idx = 0,
}
