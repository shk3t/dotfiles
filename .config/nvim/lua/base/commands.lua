local jlib = require("lib.jupyter")

vim.cmd([[command! Cdc cd %:p:h]])

vim.api.nvim_create_user_command("NewNotebook", function(opts)
  jlib.new_notebook(opts.args)
end, {
  nargs = 1,
  complete = "file",
})
