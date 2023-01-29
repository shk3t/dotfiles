vim.g.miniindentscope_disable = true

local indentscope = require("mini.indentscope")

indentscope.setup({
    draw = {delay = 0, animation = indentscope.gen_animation.none()},

    mappings = {
        object_scope = "ii",
        object_scope_with_border = "ai",

        goto_top = "[I",
        goto_bottom = "]I",
    },

    options = {
        border = "both",
        indent_at_cursor = false,
        try_as_border = false,
    },
    symbol = "|",
})
