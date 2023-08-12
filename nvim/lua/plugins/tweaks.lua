local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local lib = require("lib.main")

require("Comment").setup()
require('xkbswitch').setup()

local spider = require("spider")
keymap({"n", "o", "x"}, "w", function() spider.motion("w") end, {
  desc = "Spider-w",
})
keymap({"n", "o", "x"}, "e", function() spider.motion("e") end, {
  desc = "Spider-e",
})
keymap({"n", "o", "x"}, "b", function() spider.motion("b") end, {
  desc = "Spider-b",
})
keymap({"n", "o", "x"}, "ge", function() spider.motion("ge") end, {
  desc = "Spider-ge",
})

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
