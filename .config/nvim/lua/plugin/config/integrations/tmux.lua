local keymap = vim.keymap.set
local tmux = require("tmux")

tmux.setup({
  copy_sync = {
    enable = false,
  },
  navigation = {
    -- enables default keybindings (C-hjkl) for normal mode
    enable_default_keybindings = false,
    -- cycles to opposite pane while navigating into the border
    cycle_navigation = true,
    -- prevents unzoom tmux when navigating beyond vim border
    persist_zoom = false,
  },
  resize = {
    -- enables default keybindings (A-hjkl) for normal mode
    enable_default_keybindings = false,
    -- sets resize steps for x axis
    resize_step_x = 3,
    -- sets resize steps for y axis
    resize_step_y = 1,
  },
})

keymap({ "n", "x" }, "<A-h>", tmux.move_left)
keymap({ "n", "x" }, "<A-j>", tmux.move_bottom)
keymap({ "n", "x" }, "<A-k>", tmux.move_top)
keymap({ "n", "x" }, "<A-l>", tmux.move_right)
keymap({ "n", "x" }, "<A-H>", tmux.resize_left)
keymap({ "n", "x" }, "<A-J>", tmux.resize_bottom)
keymap({ "n", "x" }, "<A-K>", tmux.resize_top)
keymap({ "n", "x" }, "<A-L>", tmux.resize_right)
