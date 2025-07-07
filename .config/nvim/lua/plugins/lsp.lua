local ulib = require("lib.utils")
local servers = require("global.lsp").servers
local lspconfig = require("lspconfig")
local telescope_builtin = require("telescope.builtin")
local keymap = vim.keymap.set
local VERTICAL_BORDERS = require("lib.consts").VERTICAL_BORDERS

require("mason").setup()

local function base_init(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

for _, default_key in pairs({ "grn", "gra", "grr", "gri" }) do
  vim.keymap.del("n", default_key)
end
keymap({ "n", "v" }, "<Space>LR", vim.cmd.LspRestart)
keymap({ "n", "v" }, "<Space>LI", vim.cmd.LspInfo)

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
    ulib.norm("<LeftMouse>")
    vim.lsp.buf.definition()
  end, { buffer = bufnr })
  keymap("n", "<C-RightMouse>", function()
    ulib.norm("<LeftMouse>")
    vim.lsp.buf.references()
  end, { buffer = bufnr })

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
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
    on_attach = function(client, bufnr)
      base_attach(client, bufnr)
      if config.enable_formatting == false then
        client.server_capabilities.documentFormattingProvider = false
      end
      pcall(config.custom_attach, client, bufnr)
    end,
    capabilities = updated_capabilities,
    flags = { debounce_text_changes = nil },
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = VERTICAL_BORDERS,
})

require("lazydev").setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
