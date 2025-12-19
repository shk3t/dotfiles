local keymap = vim.keymap.set
local conform = require("conform")
local consts = require("consts")

conform.setup({
  default_format_opts = {
    lsp_format = "never",
  },
  formatters = {
    stylua = { append_args = { "--config-path", consts.NVIM_ETC .. "/stylua.toml" } },
    prettier = { append_args = { "--config", consts.NVIM_ETC .. "/prettier.json" } },
    ["clang-format"] = { append_args = { "-style=file:" .. consts.NVIM_ETC .. "/clang-format.txt" } },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "ruff_organize_imports" },
    go = { "golines" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    c = { "clang-format" },
    cpp = { "clang-format" },
  },
})

keymap({ "n", "x" }, "=", conform.format)
