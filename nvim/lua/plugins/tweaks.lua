local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local lib = require("lib.main")

require("Comment").setup()
-- require('xkbswitch').setup()

local spider = require("spider")
vim.g.spider_mappings = false

local function toggle_spider_keymaps()
  if not vim.g.spider_mappings then
    for _, key in pairs({"w", "e", "b", "ge"}) do
      keymap({"n", "o", "x"}, key, function() spider.motion(key) end, {
        desc = "Spider-" .. key,
      })
    end
  else
    for _, key in pairs({"w", "e", "b", "ge"}) do vim.keymap.set({"n", "o", "x"}, key, key) end
  end
  vim.g.spider_mappings = not vim.g.spider_mappings
  print("Spider mappings: " .. tostring(vim.g.spider_mappings))
end
vim.keymap.set({"n", "o", "x"}, "<S-Space>", toggle_spider_keymaps)

require("nvim-surround").setup({
  keymaps = {
    normal = "s",
    normal_cur = "ss",
    normal_cur_line = "S",
    visual = "s",
    delete = "ds",
    change = "cs",
    insert_line = false,
    insert = false,
  },
  surrounds = {
    ["("] = {add = {"(", ")"}},
    ["{"] = {add = {"{", "}"}},
    ["<"] = {add = {"<", ">"}},
    ["["] = {add = {"[", "]"}},
  },
  aliases = {["c"] = "f", ["("] = ")", ["{"] = "}", ["<"] = ">", ["["] = "]"},
  move_cursor = false,
})

require("recorder").setup({
  slots = {"q", "b"},
  mapping = {
    startStopRecording = "q",
    playMacro = "@",
    switchSlot = "Q",
    editMacro = "cq",
    yankMacro = "yq",
    addBreakPoint = [[\b]],
  },
  clear = false,
  logLevel = vim.log.levels.OFF,
  lessNotifications = true,
  dapSharedKeymaps = false,
})

local marks = require("marks")
marks.setup({
  default_mappings = false,
  -- force_write_shada = true,
  mappings = {
    toggle = "m;",
    prev = "[m",
    next = "]m",
    delete_line = "dm;",
    preview = "m:",
  },
})
keymap("n", "[m", function()
  lib.save_jump()
  marks.prev()
end)
keymap("n", "]m", function()
  lib.save_jump()
  marks.next()
end)

-- local harpoon_ui = require("harpoon.ui")
-- keymap("n", "<Space>ha", require("harpoon.mark").add_file)
-- keymap("n", "<Space>hh", harpoon_ui.toggle_quick_menu)
-- for i = 1, 9 do keymap("n", "'" .. i, function() harpoon_ui.nav_file(i) end) end
