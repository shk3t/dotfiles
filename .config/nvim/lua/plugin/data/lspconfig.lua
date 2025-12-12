local consts = require("consts")

local M = {}

M.configs = {
  -- https://github.com/LuaLS/lua-language-server/blob/ed350080cfb3998fa95abb905cfa363f546e70ce/doc/en-us/config.md
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { severity = { ["missing-fields"] = "Hint" } },
      },
    },
  },
  -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md
  -- https://docs.basedpyright.com/latest/configuration/config-files/
  -- https://docs.basedpyright.com/latest/configuration/language-server-settings/
  basedpyright = {
    settings = {
      python = {
        analysis = {
          ignore = { "*" }, -- Using Ruff
          typeCheckingMode = "off", -- Using mypy
        },
      },
    },
  },
  -- https://github.com/astral-sh/ruff-lsp/issues/384
  -- https://docs.astral.sh/ruff/editors/settings
  ruff = {
    init_options = {
      settings = {
        configuration = consts.NVIM_ETC .. "/ruff.toml",
        configurationPreference = "filesystemFirst",
      },
    },
  },
  gopls = {},
  bashls = {},
  -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
  vtsls = {},
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

M.server_capabilities = {}

return M
