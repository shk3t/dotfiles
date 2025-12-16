return {
  dap = {
    focus = {
      thread = {
        id = nil,
        name = nil,
      },
    },
  },
  spider_mappings = true,

  preserved_position = nil,
  cache = {},
  local_config = {},

  main_term = {
    buf = -1,
    win = -1,
    mode = "t",
  },

  system = {
    terminal_window_id = -1,
    tmux_window_id = -1,
    mode_layout_idx = 0,
  },
}
