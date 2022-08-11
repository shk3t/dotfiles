local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
-- local code_actions = null_ls.builtins.code_actions
-- local diagnostics = null_ls.builtins.diagnostics

local NVIM_ETC = os.getenv("HOME") .. "/.config/nvim/etc"

null_ls.setup({
    debug = false,
    sources = {
        formatting.prettier.with({
            extra_args = {"--config", NVIM_ETC .. "/prettier.json"},
        }),
        formatting.black.with({extra_args = {"--fast"}}),
        -- formatting.stylua.with({ extra_args = { "--config-path", NVIM_ETC .. "/stylua.toml" } }),
        formatting.lua_format.with({
            extra_args = {"--config", NVIM_ETC .. "/lua-format.yaml"},
        }),
        formatting.djhtml,
        -- formatting.sqlfluff.with({extra_args = {"--dialect", "postgres"}}),
        -- formatting.sql_formatter.with({extra_args = {"--config", NVIM_ETC .. "/sql-formatter.json"}})

        -- code_actions.refactoring

        -- diagnostics.sqlfluff.with({extra_args = {"--dialect", "postgres"}})
    },
})
