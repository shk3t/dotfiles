local keymap = vim.keymap.set
local state = require("state")

local function toggle_spider_keymaps()
  if not state.spider_mappings then
    for _, key in pairs({ "w", "e", "b", "ge" }) do
      keymap({ "n", "x", "o" }, key, "<Cmd>lua require('spider').motion('" .. key .. "')<CR>")
    end
  else
    for _, key in pairs({ "w", "e", "b", "ge" }) do
      keymap({ "n", "x", "o" }, key, key)
    end
  end
  state.spider_mappings = not state.spider_mappings
end

-- For cyrillic support on Arch: `sudo pacman -S lua51-luautf8`
require("spider").setup()

if state.spider_mappings then
  state.spider_mappings = false
  toggle_spider_keymaps()
end

keymap({ "n", "x" }, "<Space><Space>", toggle_spider_keymaps)
