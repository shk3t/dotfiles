local keymap = vim.keymap.set
local conform = require("conform")
local NVIM_ETC = vim.fn.stdpath("config") .. "/etc" -- TODO: move to consts

-- TODO: enable default lsp formatter because it seems to be compatible
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- python = { "black" },
		javascript = { "prettier" },
		go = { "golines" },
	},
})

-- local null_ls = require("null-ls")
--
-- null_ls.setup({
--   debug = false,
--   sources = {
--     -- null_ls.builtins.diagnostics.typos,
--     null_ls.builtins.formatting.prettier.with({
--       extra_args = { "--config", NVIM_ETC .. "/prettier.json" },
--     }),
--     null_ls.builtins.formatting.stylua.with({
--       extra_args = { "--config-path", NVIM_ETC .. "/stylua.toml" },
--     }),
--     null_ls.builtins.formatting.clang_format.with({
--       extra_args = { "-style=file:" .. NVIM_ETC .. "/clang-format.txt" },
--     }),
--     null_ls.builtins.formatting.golines,
--   },
-- })
