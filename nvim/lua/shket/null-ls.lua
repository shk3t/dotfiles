local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local NVIM_ETC = os.getenv("HOME") .. "/.config/nvim/etc"

null_ls.setup({
    debug = false,
    sources = {
        formatting.prettier.with({
            extra_args = {"--config", NVIM_ETC .. "/prettier.json"},
        }),
        formatting.black.with({extra_args = {"--fast"}}),
        formatting.lua_format.with({
            extra_args = {"--config", NVIM_ETC .. "/lua-format.yaml"},
        }),
        formatting.djhtml,
        formatting.clang_format.with({
            extra_args = {"-style=file:" .. NVIM_ETC .. "/clang-format.txt"},
        }),

        -- diagnostics.clang_check,
    },
})
