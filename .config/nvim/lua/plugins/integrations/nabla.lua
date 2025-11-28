vim.keymap.set("n", "<Space>lk", function()
  require("nabla").popup({ border = require("lib.consts").VERTICAL_BORDERS })
end)
vim.keymap.set("n", "<Space>LK", require("nabla").toggle_virt)
