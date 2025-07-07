local keymap = vim.keymap.set
local ulib = require("lib.utils")

require("Comment").setup()

local spider = require("spider")
vim.g.spider_mappings = false

local function toggle_spider_keymaps()
  if not vim.g.spider_mappings then
    for _, key in pairs({"w", "e", "b", "ge"}) do
      keymap({"n", "o", "v"}, key, function() spider.motion(key) end, {
        desc = "Spider-" .. key,
      })
    end
  else
    for _, key in pairs({"w", "e", "b", "ge"}) do keymap({"n", "o", "v"}, key, key) end
  end
  vim.g.spider_mappings = not vim.g.spider_mappings
  print("Spider mappings: " .. tostring(vim.g.spider_mappings))
end
keymap({"n", "o", "v"}, "<Space><Space>", toggle_spider_keymaps)
-- toggle_spider_keymaps()

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
  mappings = {
    toggle = "m;",
    prev = "[m",
    next = "]m",
    delete_line = "dm",
    preview = "m:",
  },
})
keymap("n", "[m", function()
  ulib.save_jump()
  marks.prev()
end)
keymap("n", "]m", function()
  ulib.save_jump()
  marks.next()
end)
