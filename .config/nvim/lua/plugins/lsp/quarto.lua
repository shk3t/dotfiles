local autocmd = vim.api.nvim_create_autocmd
local quarto = require("quarto")

-- Quarto: Molten LSP integration
quarto.setup({
  lspFeatures = {
    -- NOTE: put whatever languages you want here:
    languages = { "r", "python", "rust" },
    chunks = "all",
    -- diagnostics = {
    --   enabled = true,
    --   triggers = { "InsertLeave", "TextChanged" },
    -- },
    -- completion = {
    --   enabled = true,
    -- },
  },
  codeRunner = {
    enabled = true,
    default_method = "molten",
  },
})
-- activate LSP on entering markdown buffer
autocmd("FileType", {
  pattern = "markdown",
  callback = quarto.activate,
})
