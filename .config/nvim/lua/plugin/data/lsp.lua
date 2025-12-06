local keymap = vim.keymap.set
local strings = require("lib.base.string")

-- TODO

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
    enable_formatting = false,
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
    enable_formatting = false,
  },
  html = {
    enable_formatting = false,
  },
  cssls = {
    enable_formatting = false,
  },
  cssmodules_ls = true,
  jsonls = {
    enable_formatting = false,
  },
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
    enable_formatting = false,
  },
  bashls = true,
  texlab = true,
  -- https://github.com/LuaLS/lua-language-server/blob/ed350080cfb3998fa95abb905cfa363f546e70ce/doc/en-us/config.md
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = "Lua 5.1",
          path = strings.split(vim.env.LUA_PATH, ";"),
        },
        workspace = {
          checkThirdParty = false,
          library = { "/usr/share/lua/5.4/", "/usr/share/lua/5.1/" },
        },
        diagnostics = { severity = { ["missing-fields"] = "Hint!" } },
        telemetry = { enable = false },
      },
    },
    enable_formatting = false,
  },
  gopls = {
    enable_formatting = false,
  },
  jdtls = true,
  marksman = {
    enable_formatting = false,
  },
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
  },
  buf_ls = true,
}

return M
