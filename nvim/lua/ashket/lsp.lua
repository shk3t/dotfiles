require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "clangd",
        "cssls",
        "html",
        "jsonls",
        "sumneko_lua",
        "pyright",
        "jedi_language_server",
        "sqls",
        "texlab",
        "tsserver",
    },
})
require("mason-null-ls").setup({
    ensure_installed = {"black", "clang-format", "luaformatter", "prettier"},
})

local keymap = vim.api.nvim_set_keymap
local buf_keymap = vim.api.nvim_buf_set_keymap
local opts = {noremap = true, silent = true}
local NVIM_ETC = os.getenv("HOME") .. "/.config/nvim/etc"
-- local HOME = os.getenv("HOME")
-- local GOPATH = os.getenv("GOPATH")

-- keymap("n", "<space>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
keymap("n", "<Space>td", "<cmd>lua require('telescope.builtin').diagnostics()<CR>", opts)

local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

            buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            buf_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
            buf_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
            buf_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
            buf_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

            buf_keymap(bufnr, "n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", opts)
            buf_keymap(bufnr, "n", "gD", "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", opts)
            buf_keymap(bufnr, "n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", opts)
            buf_keymap(bufnr, "n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)

            client.server_capabilities.documentFormattingProvider = false

        end,
    }, _config or {})
end

vim.diagnostic.config({
    virtual_text = false,
    underline = {severity = {min = "WARN"}},
    signs = true,
    update_in_insert = false,
})
-- require("neodim").setup({alpha = 0.6, update_in_insert = {enable = false}})

local lspconfig = require("lspconfig")

-- lspconfig.pyright.setup(config())
lspconfig.jedi_language_server.setup(config())
-- lspconfig.pylsp.setup(config())

-- lspconfig.ccls.setup(config())
lspconfig.clangd.setup(config({
    cmd = {
        "clangd",
        -- "--all-scopes-completion=true",
        -- "--background-index=true",
        "--completion-style=bundled",
        "--function-arg-placeholders=false",
        "--header-insertion=iwyu",
        "--header-insertion-decorators=false",
        "--offset-encoding=utf-16",
    },
}))

-- lspconfig.asm_lsp.setup(config())

lspconfig.bashls.setup(config())

lspconfig.html.setup(config({filetypes = {"html", "htmldjango"}}))

lspconfig.cssls.setup(config())

lspconfig.tsserver.setup(config({
    init_options = {preferences = {providePrefixAndSuffixTextForRename = false}},
}))

lspconfig.jsonls.setup(config())

lspconfig.texlab.setup(config())

lspconfig.sqls.setup(config())

-- if GOPATH then
--     lspconfig.sqls.setup(config({
--         cmd = {
--             GOPATH .. "/bin/sqls",
--             "-config",
--             HOME .. "/.config/nvim/etc/sqls.yml",
--         },
--     }))
-- end
-- lspconfig.sqlls.setup(config())

lspconfig.sumneko_lua.setup(config({
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim"},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {enable = false},
        },
    },
}))

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
null_ls.setup({
    debug = false,
    sources = {
        -- formatting.prettier.with({
        --     extra_args = {"--config", NVIM_ETC .. "/prettier.json"},
        -- }),
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
