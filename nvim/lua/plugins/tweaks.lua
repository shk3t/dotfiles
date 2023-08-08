local keymap = vim.keymap.set

require("Comment").setup()

local spider = require("spider")
keymap({"n", "o", "x"}, "w", function() spider.motion("w") end)
keymap({"n", "o", "x"}, "e", function() spider.motion("e") end)
keymap({"n", "o", "x"}, "b", function() spider.motion("b") end)
keymap({"n", "o", "x"}, "ge", function() spider.motion("ge") end)

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

require("marks").setup({
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

-- local harpoon_ui = require("harpoon.ui")
-- keymap("n", "<Space>ha", require("harpoon.mark").add_file)
-- keymap("n", "<Space>hh", harpoon_ui.toggle_quick_menu)
-- for i = 1, 9 do keymap("n", "'" .. i, function() harpoon_ui.nav_file(i) end) end

-- require("grapple").setup()
-- vim.keymap.set("n", "<leader>m", require("grapple").toggle)
