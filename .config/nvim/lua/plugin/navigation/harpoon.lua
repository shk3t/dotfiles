local consts = require("consts")
local harpoon = require("harpoon")
local harpoon_extensions = require("harpoon.extensions")

harpoon:setup()
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

vim.keymap.set("n", "<Space>h", function()
  harpoon.ui:toggle_quick_menu(harpoon:list(), {
    border = consts.ICONS.ALT_BORDER,
    title_pos = "center",
    title = " Harpoon ",
    ui_max_width = 80,
    height_in_lines = 16,
  })
end)
vim.keymap.set("n", "<Space>ah", function()
  harpoon:list():add()
end)
vim.keymap.set("n", "[h", function()
  harpoon:list():prev({ui_nav_wrap = true})
end)
vim.keymap.set("n", "]h", function()
  harpoon:list():next({ui_nav_wrap = true})
end)
for i = 1, 9 do
  vim.keymap.set("n", "'" .. i, function()
    harpoon:list():select(i)
  end)
end
