local keymap = vim.keymap.set

require("Comment").setup()

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

require("trevj").setup()
keymap("n", "U", require("trevj").format_at_cursor)

local harpoon_ui = require("harpoon.ui")
keymap("n", "<Space>ha", require("harpoon.mark").add_file)
keymap("n", "<Space>hh", harpoon_ui.toggle_quick_menu)
for i = 1, 9 do keymap("n", "'" .. i, function() harpoon_ui.nav_file(i) end) end

-- require("grapple").setup()
-- vim.keymap.set("n", "<leader>m", require("grapple").toggle)

require("marks").setup({
  default_mappings = false,
  mappings = {
    toggle = "m;",
    prev = "[m",
    next = "]m",
    delete_line = "dm;",
    delete_buf = "dM",
    preview = "m:",
  },
})
keymap("n", [[<Space>"]], vim.cmd.MarksListAll)
