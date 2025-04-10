local lib = require("lib.main")
local keymap = vim.keymap.set

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

M.servers = {
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
        runtime = {
          version = "Lua 5.1",
          path = lib.split_string(vim.env.LUA_PATH, ";"),
        },
        workspace = {
          checkThirdParty = false,
          library = { "/usr/share/lua/5.4/", "/usr/share/lua/5.1/" },
        },
        diagnostics = { severity = { ["missing-fields"] = "Hint!" } },
        telemetry = { enable = false },
      },
    },
  },
  gopls = true,
  jdtls = true,
  marksman = true,
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        -- checkOnSave = {
        --   command = "clippy",
        -- },
        diagnostics = {
          enable = true,
          experimental = {
            enable = false,
          },
        },
      },
    },
    custom_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
    end,
  },
}

return M
