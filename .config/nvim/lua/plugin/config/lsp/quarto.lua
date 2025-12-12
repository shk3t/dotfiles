local autocmd = vim.api.nvim_create_autocmd
local quarto = require("quarto")

quarto.setup({
  lspFeatures = {
    chunks = "all",
  },
  codeRunner = {
    default_method = "molten",
  },
})

autocmd("FileType", {
  pattern = "markdown",
  callback = quarto.activate,
})
