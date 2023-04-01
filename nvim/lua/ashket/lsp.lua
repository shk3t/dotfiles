local lspconfig = vim.F.npcall(require, "lspconfig")
local null_ls = require("null-ls")
local nformatting = null_ls.builtins.formatting
local ndiagnostics = null_ls.builtins.diagnostics
local ncode_actions = null_ls.builtins.code_actions
local keymap = vim.keymap.set
local buf_keymap = vim.api.nvim_buf_set_keymap
local opts = {noremap = true, silent = true}
local NVIM_ETC = os.getenv("HOME") .. "/.config/nvim/etc"

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
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- -- Set autocommands conditional on server_capabilities
  -- if client.server_capabilities.documentHighlightProvider then
  --   autocmd_clear { group = augroup_highlight, buffer = bufnr }
  --   autocmd { "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, bufnr }
  --   autocmd { "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, bufnr }
  -- end
end

local turn_off_lsp_diagnostics = function() vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end end

local no_lsp_diagnostics_attach = function(client, bufnr)
  custom_attach(client, bufnr)
  turn_off_lsp_diagnostics()
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    flags = {debounce_text_changes = nil},
  }, config)

  lspconfig[server].setup(config)
end

local servers = {
  pyright = true,
  -- jedi_language_server = true,
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       plugins = {
  --         pycodestyle = {
  --           ignore = {
  --             "W191", -- Indentation contains tabs
  --             "W292", -- No newline at end of file
  --             "W391", -- Blank line at end of file
  --             "W503", -- Line break before binary operator
  --             "E101", -- Indentation contains mixed spaces and tabs
  --             "E302", -- Expected 2 blank lines, found 0
  --             "E501", -- Line too long (82 > 79 characters)
  --           },
  --           maxLineLength = 100,
  --         },
  --       },
  --     },
  --   },
  -- },

  html = true,
  cssls = true,
  -- eslint = true,
  tsserver = {
    init_options = {preferences = {providePrefixAndSuffixTextForRename = false}},
  },
  jsonls = true,

  -- ccls = true,
  clangd = {
    cmd = {
      "clangd",
      "--background-index=true",
      "--completion-style=bundled",
      "--function-arg-placeholders=false",
      "--header-insertion=iwyu",
      "--header-insertion-decorators=false",
      "--offset-encoding=utf-16",
      -- "--all-scopes-completion=true",
      -- "--clang-tidy",
    },
  },

  bashls = true,

  texlab = true,

  sqls = true, -- Deprecated

  lua_ls = true,
}

for server, config in pairs(servers) do
  setup_server(server, config)
end

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = "none",
-- })

vim.diagnostic.config({
  virtual_text = {severity = {min = "WARN"}},
  underline = {severity = {min = "WARN"}},
  signs = true,
  update_in_insert = false,
  -- float = {border = "none"},
})

keymap("n", "[d", vim.diagnostic.goto_prev)
keymap("n", "]d", vim.diagnostic.goto_next)
keymap("n", "<Space>td", require("telescope.builtin").diagnostics)
-- require("neodim").setup({alpha = 0.6, update_in_insert = {enable = false}})

null_ls.setup({
  debug = false,
  sources = {
    nformatting.prettier.with({
      extra_args = {"--config", NVIM_ETC .. "/prettier.json"},
    }),
    -- nformatting.black.with({extra_args = {"--fast"}}),
    nformatting.autopep8,
    nformatting.lua_format.with({
      extra_args = {"--config", NVIM_ETC .. "/lua-format.yaml"},
    }),
    nformatting.djhtml,
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
