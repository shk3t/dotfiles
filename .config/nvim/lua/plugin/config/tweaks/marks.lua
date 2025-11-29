local cmds = require("lib.cmds")
local keymap = vim.keymap.set

local marks = require("marks")
marks.setup({
  default_mappings = false,
  mappings = {
    toggle = "m;",
    prev = "[m",
    next = "]m",
    delete_line = "dm",
    preview = "m:",
  },
})
keymap("n", "[m", function()
  cmds.save_jump()
  marks.prev()
end)
keymap("n", "]m", function()
  cmds.save_jump()
  marks.next()
end)
