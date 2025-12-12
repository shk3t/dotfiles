local keymap = vim.keymap.set
local set_preset = require("treesj.langs.utils").set_default_preset
local tsj = require("treesj")

local commas = set_preset({
  both = { separator = "," },
  split = { last_separator = true },
})

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 150,
  cursor_behavior = "hold",
  notify = true,
  langs = {
    python = {
      argument_list = commas,
      tuple = commas,
    },
  },
  dot_repeat = true,
})

keymap("n", "U", tsj.toggle)
