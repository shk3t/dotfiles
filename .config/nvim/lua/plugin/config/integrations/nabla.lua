local keymap = vim.keymap.set
local consts = require("consts")
local nabla = require("nabla")

keymap("n", "<Space>lk", function()
  nabla.popup({ border = consts.ICONS.BORDER })
end)
keymap("n", "<Space>LK", nabla.toggle_virt)
