local NVIM_ETC = vim.fn.stdpath("config") .. "/etc"
local null_ls = require("null-ls")

null_ls.setup({
  debug = false,
  sources = {
    -- null_ls.builtins.diagnostics.typos,
    null_ls.builtins.formatting.prettier.with({
      extra_args = { "--config", NVIM_ETC .. "/prettier.json" },
    }),
    -- null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
    -- null_ls.builtins.formatting.pyink.with({ extra_args = { "--fast" } }),
    -- null_ls.builtins.formatting.isort.with({ extra_args = { "--profile", "black" } }),
    -- null_ls.builtins.formatting.luaformatter.with({
    --   extra_args = {"--config", NVIM_ETC .. "/lua-format.yaml"},
    -- }),
    null_ls.builtins.formatting.stylua.with({
      extra_args = { "--config-path", NVIM_ETC .. "/stylua.toml" },
    }),
    null_ls.builtins.formatting.clang_format.with({
      extra_args = { "-style=file:" .. NVIM_ETC .. "/clang-format.txt" },
    }),
    -- null_ls.builtins.formatting.goimports,
    -- null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.golines,
  },
})

-- require("go").setup({disable_defaults = true})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "json" },
--   callback = function()
--     vim.bo.formatprg = "jq"
--   end,
-- })
