local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local telescope_builtin = require("telescope.builtin")
local lib = require("lib.main")
local pylsp_paths = require("local.lsp").pylsp_paths
local keymap = vim.keymap.set
local NVIM_ETC = vim.fn.stdpath("config") .. "/etc"
local VERTICAL_BORDERS = require("lib.consts").VERTICAL_BORDERS

require("mason").setup()
require("mason-lspconfig").setup({
  -- ensure_installed = {
  --   "bashls",
  --   "clangd",
  --   "html",
  --   "cssls",
  --   "cssmodules_ls",
  --   "jsonls",
  --   "lua_ls",
  --   "pyright",
  --   "jedi_language_server",
  --   "pylsp",
  --   "sqls",
  --   "texlab",
  --   "tsserver",
  --   "gopls",
  -- },
})
require("mason-null-ls").setup({
  -- ensure_installed = {
  --   "black",
  --   "clang-format",
  --   "luaformatter",
  --   "prettier",
  --   "pylint",
  -- },
})

local function base_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local function base_attach(client, bufnr)
  keymap("n", "K", vim.lsp.buf.hover, {buffer = bufnr})
  -- keymap("n", "<C-k>", vim.lsp.buf.signature_help, {buffer = bufnr})
  keymap("n", "<Space>rn", vim.lsp.buf.rename, {buffer = bufnr})
  keymap("n", "<Space>ca", vim.lsp.buf.code_action, {buffer = bufnr})
  keymap({"n", "x"}, "<Space>F", vim.lsp.buf.format, {buffer = bufnr})

  keymap("n", "gd", telescope_builtin.lsp_definitions, {buffer = bufnr})
  keymap("n", "gD", telescope_builtin.lsp_type_definitions, {buffer = bufnr})
  keymap("n", "gi", telescope_builtin.lsp_implementations, {buffer = bufnr})
  keymap("n", "gr", telescope_builtin.lsp_references, {buffer = bufnr})

  keymap("n", "<C-LeftMouse>", function()
    lib.norm("<LeftMouse>")
    vim.lsp.buf.definition()
  end, {buffer = bufnr})
  keymap("n", "<C-RightMouse>", function()
    lib.norm("<LeftMouse>")
    vim.lsp.buf.references()
  end, {buffer = bufnr})

  -- if false then vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end end

  client.server_capabilities.documentFormattingProvider = false
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

local function attach(custom_attach)
  return function(client, bufnr)
    base_attach(client, bufnr)
    custom_attach(client, bufnr)
  end
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

local function setup_server(server, config)
  if not config then return end

  if type(config) ~= "table" then config = {} end

  config = vim.tbl_deep_extend("force", {
    on_init = base_init,
    on_attach = base_attach,
    capabilities = updated_capabilities,
    flags = {debounce_text_changes = nil},
  }, config)

  lspconfig[server].setup(config)
end

local tss_spaces_inside_braces = false
local tss_settings = {
  format = {
    insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = tss_spaces_inside_braces,
    insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = tss_spaces_inside_braces,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = tss_spaces_inside_braces,
    insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = tss_spaces_inside_braces,
  },
}
local use_pylsp = false
for _, path in ipairs(pylsp_paths) do if lib.cwd_contains(path) then use_pylsp = true end end
local servers = {
  pyright = not use_pylsp and {
    on_attach = attach(function(client, bufnr)
      keymap("n", "<Space>o", vim.cmd.PyrightOrganizeImports, {buffer = bufnr})
    end),
  },
  pylsp = use_pylsp and {
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
  -- https://github.com/typescript-language-server/typescript-language-server
  tsserver = {
    init_options = {preferences = {providePrefixAndSuffixTextForRename = false}},
    settings = {javascript = tss_settings, typescript = tss_settings},
  },
  html = true,
  cssls = true,
  cssmodules_ls = true,
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
  -- https://github.com/LuaLS/lua-language-server/blob/ed350080cfb3998fa95abb905cfa363f546e70ce/doc/en-us/config.md
  lua_ls = {
    settings = {
      Lua = {
        runtime = {path = lib.split_string(vim.env.LUA_PATH, ";")},
        workspace = {
          checkThirdParty = false,
          library = {"/usr/share/lua/5.4/", "/usr/share/lua/5.1/"},
        },
        diagnostics = {severity = {["missing-fields"] = "Hint!"}},
      },
    },
  },
  gopls = true,
}

for server, config in pairs(servers) do setup_server(server, config) end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = VERTICAL_BORDERS,
})

null_ls.setup({
  debug = false,
  sources = {
    null_ls.builtins.formatting.prettier.with({
      extra_args = {"--config", NVIM_ETC .. "/prettier.json"},
    }),
    null_ls.builtins.formatting.black.with({extra_args = {"--fast"}}),
    -- null_ls.builtins.formatting.autopep8,
    null_ls.builtins.formatting.lua_format.with({
      extra_args = {"--config", NVIM_ETC .. "/lua-format.yaml"},
    }),
    -- null_ls.builtins.formatting.stylua.with({
    --   extra_args = { "--config-path", NVIM_ETC .. "/stylua.toml" },
    -- }),
    -- null_ls.builtins.formatting.djhtml,
    null_ls.builtins.formatting.clang_format.with({
      extra_args = {"-style=file:" .. NVIM_ETC .. "/clang-format.txt"},
    }),
    -- diagnostics.clang_check,
    -- ndiagnostics.pylint.with({
    --     -- command = "/home/ashket/repos/s11/.venv/bin/pylint",
    --     -- args = {"--from-stdin", "$FILENAME", "-f", "json"},
    --     extra_args = {"--rcfile", NVIM_ETC .. "/pylint.toml"},
    -- }),
    -- null_ls.builtins.formatting.gitsigns,
  },
})

-- require("neodev").setup()
