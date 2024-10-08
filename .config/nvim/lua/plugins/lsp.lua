local lib = require("lib.main")
local lspconfig = require("lspconfig")
local telescope_builtin = require("telescope.builtin")
local keymap = vim.keymap.set
local VERTICAL_BORDERS = require("lib.consts").VERTICAL_BORDERS

require("mason").setup()

local function base_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local function base_attach(client, bufnr)
  keymap("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  -- keymap("n", "<C-k>", vim.lsp.buf.signature_help, {buffer = bufnr})
  keymap("n", "<Space>rn", vim.lsp.buf.rename, { buffer = bufnr })
  keymap("n", "<Space>ca", vim.lsp.buf.code_action, { buffer = bufnr })
  keymap({ "n", "v" }, "<Space>F", vim.lsp.buf.format, { buffer = bufnr })

  keymap("n", "gd", telescope_builtin.lsp_definitions, { buffer = bufnr })
  keymap("n", "gD", telescope_builtin.lsp_type_definitions, { buffer = bufnr })
  keymap("n", "gI", telescope_builtin.lsp_implementations, { buffer = bufnr })
  keymap("n", "gr", telescope_builtin.lsp_references, { buffer = bufnr })
  keymap("n", "gi", telescope_builtin.lsp_incoming_calls, { buffer = bufnr })
  keymap("n", "go", telescope_builtin.lsp_outgoing_calls, { buffer = bufnr })

  keymap("n", "<C-LeftMouse>", function()
    lib.norm("<LeftMouse>")
    vim.lsp.buf.definition()
  end, { buffer = bufnr })
  keymap("n", "<C-RightMouse>", function()
    lib.norm("<LeftMouse>")
    vim.lsp.buf.references()
  end, { buffer = bufnr })

  -- if false then vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end end

  client.server_capabilities.documentFormattingProvider = false
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

local function attach(custom_attach)
  return function(client, bufnr)
    base_attach(client, bufnr)
    pcall(custom_attach, client, bufnr)
  end
end

local function enable_formatter_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
updated_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
vim.tbl_deep_extend("force", updated_capabilities, require("cmp_nvim_lsp").default_capabilities())
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

local function setup_server(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_init = base_init,
    on_attach = attach(config.custom_attach),
    capabilities = updated_capabilities,
    flags = { debounce_text_changes = nil },
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
local servers = {
  -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
        disableTaggedHints = true,
      },
      python = {
        analysis = {
          diagnosticSeverityOverrides = {
            -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#type-check-diagnostics-settings
            reportUndefinedVariable = "none",
            reportUnusedExpression = "none",
          },
        },
      },
    },
  },
  -- https://github.com/astral-sh/ruff-lsp/issues/384
  ruff_lsp = {
    init_options = {
      settings = {
        -- https://docs.astral.sh/ruff/rules/#pyflakes-f
        args = { "--ignore=E402,F403,F405" },
        lint = { enable = true },
      },
    },
    custom_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
      keymap({ "n", "v" }, "<Space>I", function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end, { buffer = bufnr })
    end,
  },
  -- https://github.com/typescript-language-server/typescript-language-server
  ts_ls = {
    init_options = { preferences = { providePrefixAndSuffixTextForRename = false } },
    settings = { javascript = tss_settings, typescript = tss_settings },
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
        runtime = { path = lib.split_string(vim.env.LUA_PATH, ";") },
        workspace = {
          checkThirdParty = false,
          library = { "/usr/share/lua/5.4/", "/usr/share/lua/5.1/" },
        },
        diagnostics = { severity = { ["missing-fields"] = "Hint!" } },
      },
    },
  },
  gopls = true,
  -- tabby_ml = {
  --   filetypes = { "python" },
  -- },
}

for server, config in pairs(servers) do
  setup_server(server, config)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = VERTICAL_BORDERS,
})

-- require("neodev").setup()
