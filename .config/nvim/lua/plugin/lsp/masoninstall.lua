local consts = require("consts")

require("mason-tool-installer").setup({
  ensure_installed = {
    "basedpyright",
    "debugpy",
    "delve",
    "golines",
    "gopls",
    "lua-language-server",
    "prettier",
    "ruff",
    "stylua",
    "tree-sitter-cli",
    "vtsls",
  },
  auto_update = false,
  run_on_start = consts.MASON_ENSURE_INSTALLED,
  integrations = {
    ["mason-lspconfig"] = false,
    ["mason-null-ls"] = false,
    ["mason-nvim-dap"] = false,
  },
})
