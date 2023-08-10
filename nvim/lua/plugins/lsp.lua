local lspconfig = vim.F.npcall(require, "lspconfig")
local null_ls = require("null-ls")
local nformatting = null_ls.builtins.formatting
local ndiagnostics = null_ls.builtins.diagnostics
local ncode_actions = null_ls.builtins.code_actions
local buf_keymap = vim.api.nvim_buf_set_keymap
local opts = {noremap = true, silent = true}
local NVIM_ETC = vim.fn.stdpath("config") .. "/etc"
local VERTICAL_BORDERS = require("utils.consts").VERTICAL_BORDERS

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "clangd",
    "cssls",
    "html",
    "jsonls",
    "lua_ls",
    "pyright",
    "jedi_language_server",
    "pylsp",
    "sqls",
    "texlab",
    "tsserver",
  },
})
require("mason-null-ls").setup({
  ensure_installed = {
    "black",
    "clang-format",
    "luaformatter",
    "prettier",
    "pylint",
  },
})

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local custom_attach = function(client, bufnr)
  buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  -- buf_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  buf_keymap(bufnr, "v", "<space>F", "<cmd>lua vim.lsp.buf.format()<CR><Esc>", opts)

  buf_keymap(bufnr, "n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", opts)
  buf_keymap(bufnr, "n", "gD", "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", opts)
  buf_keymap(bufnr, "n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>", opts)
  buf_keymap(bufnr, "n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)

  client.server_capabilities.documentFormattingProvider = false
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

local turn_off_lsp_diagnostics = function() vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end end

local no_lsp_diagnostics_attach = function(client, bufnr)
  custom_attach(client, bufnr)
  turn_off_lsp_diagnostics()
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())

local setup_server = function(server, config)
  if not config then return end

  if type(config) ~= "table" then config = {} end

  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    flags = {debounce_text_changes = nil},
  }, config)

  lspconfig[server].setup(config)
end

local use_pyright = not string.find(vim.fn.getcwd(), "s11")
local servers = {
  pyright = use_pyright,
  pylsp = not use_pyright and {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = {
              "W191", -- Indentation contains tabs
              "W292", -- No newline at end of file
              "W391", -- Blank line at end of file
              "W503", -- Line break before binary operator
              "E101", -- Indentation contains mixed spaces and tabs
              "E302", -- Expected 2 blank lines, found 0
              "E501", -- Line too long (82 > 79 characters)
            },
            maxLineLength = 100,
          },
        },
      },
    },
  },
  html = true,
  cssls = true,
  tsserver = {
    init_options = {preferences = {providePrefixAndSuffixTextForRename = false}},
  },
  jsonls = true,
  clangd = {
    cmd = {
      "clangd",
      "--background-index=true",
      "--completion-style=bundled",
      "--function-arg-placeholders=false",
      "--header-insertion=iwyu",
      "--header-insertion-decorators=false",
      "--offset-encoding=utf-16",
    },
  },
  bashls = true,
  texlab = true,
  lua_ls = true,
}

for server, config in pairs(servers) do setup_server(server, config) end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = VERTICAL_BORDERS,
})

null_ls.setup({
  debug = false,
  sources = {
    nformatting.prettier.with({
      extra_args = {"--config", NVIM_ETC .. "/prettier.json"},
    }),
    nformatting.black.with({extra_args = {"--fast"}}),
    -- nformatting.autopep8,
    nformatting.lua_format.with({
      extra_args = {"--config", NVIM_ETC .. "/lua-format.yaml"},
    }),
    -- nformatting.stylua.with({
    --   extra_args = { "--config-path", NVIM_ETC .. "/stylua.toml" },
    -- }),
    -- nformatting.djhtml,
    nformatting.clang_format.with({
      extra_args = {"-style=file:" .. NVIM_ETC .. "/clang-format.txt"},
    }),
    -- diagnostics.clang_check,
    -- ndiagnostics.pylint.with({
    --     -- command = "/home/ashket/repos/s11/.venv/bin/pylint",
    --     -- args = {"--from-stdin", "$FILENAME", "-f", "json"},
    --     extra_args = {"--rcfile", NVIM_ETC .. "/pylint.toml"},
    -- }),
    ncode_actions.gitsigns,
  },
})
