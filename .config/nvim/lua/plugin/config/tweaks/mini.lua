require("mini.ai").setup()

vim.g.miniindentscope_disable = true
require("mini.indentscope").setup({
  mappings = {
    object_scope = "ii",
    object_scope_with_border = "ai",
    goto_top = "[i",
    goto_bottom = "]i",
  },
})
