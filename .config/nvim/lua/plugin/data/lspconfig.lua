local keymap = vim.keymap.set
local strings = require("lib.base.string")

local M = {}

local tss_spaces_inside_braces = false
local tss_settings = {
  format = {
    insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = tss_spaces_inside_braces,
    insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = tss_spaces_inside_braces,
    insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = tss_spaces_inside_braces,
    insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = tss_spaces_inside_braces,
  },
}

-- TODO: review
-- TODO: test ruff formatting
M.configs = {
  -- https://github.com/LuaLS/lua-language-server/blob/ed350080cfb3998fa95abb905cfa363f546e70ce/doc/en-us/config.md
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { severity = { ["missing-fields"] = "Hint!" } },
      },
    },
  },
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
  ruff = {
    init_options = {
      settings = {
        configuration = vim.fn.stdpath("config") .. "/etc/ruff.toml",
        configurationPreference = "filesystemFirst",
        lint = {
          enable = true,
        },
      },
    },
  },
  gopls = {},
  bashls = {},
  -- https://github.com/typescript-language-server/typescript-language-server
  ts_ls = {
    init_options = { preferences = { providePrefixAndSuffixTextForRename = false } },
    settings = { javascript = tss_settings, typescript = tss_settings },
  },
  html = {},
  cssls = {},
  cssmodules_ls = {},
  jsonls = {},
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
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  },
  rust_analyzer = {},
  jdtls = {},
  buf_ls = {},
  texlab = {},
}

M.server_capabilities = {
  lua_ls = { documentFormattingProvider = false },
  pyright = { documentFormattingProvider = false },
  ruff = { documentFormattingProvider = false },
  gopls = { documentFormattingProvider = false },
  ts_ls = { documentFormattingProvider = false },
  html = { documentFormattingProvider = false },
  cssls = { documentFormattingProvider = false },
  cssmodules_ls = { documentFormattingProvider = false },
  jsonls = { documentFormattingProvider = false },
  clangd = { documentFormattingProvider = false },
}

M.on_attach = {
  ruff = function(client)
    keymap("n", "<Space>I", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end, { buffer = true })
  end,
}

return M
