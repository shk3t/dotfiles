local config = require("nvim-surround.config")
local s = config.default_opts.surrounds

require("nvim-surround").setup({
  keymaps = {
    insert = false,
    insert_line = false,
    normal = "s",
    normal_cur = "ss",
    normal_line = "S",
    normal_cur_line = false,
    visual = "s",
    visual_line = "S",
    delete = "ds",
    change = "cs",
    change_line = false,
  },
  surrounds = {
    -- Swap defaults
    ["("] = s[")"],
    [")"] = s["("],
    ["{"] = s["}"],
    ["}"] = s["{"],
    ["<"] = s[">"],
    [">"] = s["<"],
    ["["] = s["]"],
    ["]"] = s["["],
  },
  aliases = {
    ["c"] = "f",
    ["a"] = ">",
    ["b"] = ")",
    ["B"] = "}",
    ["r"] = "]",
    ["q"] = { '"', "'", "`" },
    ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
  },
  move_cursor = false,
})
