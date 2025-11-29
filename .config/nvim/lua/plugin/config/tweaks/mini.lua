local indentscope = require("mini.indentscope")

vim.g.miniindentscope_disable = true

indentscope.setup({
  draw = {delay = 0, animation = indentscope.gen_animation.none()},

  mappings = {
    object_scope = "ii",
    object_scope_with_border = "ai",

    goto_top = "[i",
    goto_bottom = "]i",
  },

  options = {border = "both", indent_at_cursor = false, try_as_border = false},
  symbol = "|",
})
