local lib = require("lib.main")

vim.cmd([[command! Cdc cd %:p:h]])

vim.api.nvim_create_user_command('CodeCompanionFullscreen', function()
  vim.cmd([[CodeCompanionChat Toggle]])
  lib.norm("<C-W>l<C-W>q")
end, {})

