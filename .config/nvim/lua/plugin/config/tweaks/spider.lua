local keymap = vim.keymap.set
local spider = require("spider")

vim.g.spider_mappings = false

local function toggle_spider_keymaps()
  if not vim.g.spider_mappings then
    for _, key in pairs({ "w", "e", "b", "ge" }) do
      keymap({ "n", "x", "o" }, key, function()
        spider.motion(key)
      end, {
        desc = "Spider-" .. key,
      })
    end
  else
    for _, key in pairs({ "w", "e", "b", "ge" }) do
      keymap({ "n", "x", "o" }, key, key)
    end
  end
  vim.g.spider_mappings = not vim.g.spider_mappings
  print("Spider mappings: " .. tostring(vim.g.spider_mappings))
end

keymap({ "n", "x" }, "<Space><Space>", toggle_spider_keymaps)
