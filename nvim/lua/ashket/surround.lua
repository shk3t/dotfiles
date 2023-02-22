require("nvim-surround").setup {
    keymaps = {
        -- normal = "ys",
        -- normal_cur = "yss",
        -- normal_cur_line = "yS", -- bugged
        normal = "s",
        normal_cur = "ss",
        normal_cur_line = "S",
        visual = "s",
        delete = "ds",
        change = "cs",
    },
    surrounds = {
        ["("] = {add = {"(", ")"}},
        ["{"] = {add = {"{", "}"}},
        ["<"] = {add = {"<", ">"}},
        ["["] = {add = {"[", "]"}},
    },
    aliases = {["c"] = "f"},
    -- indent_lines = false,
    move_cursor = false,
}
