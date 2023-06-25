require("nvim-surround").setup {
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
  -- indent_lines = false,
  move_cursor = false,
}
