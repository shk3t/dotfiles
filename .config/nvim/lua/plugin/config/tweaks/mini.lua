local ai = require("mini.ai")
local consts = require("consts")

vim.g.miniindentscope_disable = true

require("mini.indentscope").setup({
  mappings = {
    object_scope = "ii",
    object_scope_with_border = "ai",
    goto_top = "[i",
    goto_bottom = "]i",
  },
})

if consts.ICONS.ENABLED then
  local icons = require("mini.icons")
  icons.setup()
  icons.mock_nvim_web_devicons()
end

ai.setup({})
