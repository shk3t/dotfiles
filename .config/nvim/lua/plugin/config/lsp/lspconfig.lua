local keymap = vim.keymap.set
local blinkcmp = require("blink.cmp")
local conform = require("conform")
local consts = require("consts")
local inputs = require("lib.base.input")
local lspdata = require("plugin.data.lspconfig")
local telescope_builtin = require("telescope.builtin")

local function setup_all_lsp_servers()
  vim.lsp.config("*", {
    capabilities = blinkcmp.get_lsp_capabilities(),
  })

  for name, config in pairs(lspdata.configs) do
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end
setup_all_lsp_servers()

for _, default_key in pairs({ "grn", "gra", "grr", "gri", "grt", "gO" }) do
  vim.keymap.del("n", default_key)
end
-- -- INFO: future releases
-- -- Don't forget to test: `inputs.norm("o")`
-- vim.keymap.set("x", "an", function()
--   vim.lsp.buf.selection_range("outer")
-- end, { desc = "vim.lsp.buf.selection_range('outer')" })
-- vim.keymap.set("x", "in", function()
--   vim.lsp.buf.selection_range("inner")
-- end, { desc = "vim.lsp.buf.selection_range('inner')" })
keymap("n", "<Space>LI", vim.cmd.LspInfo)
keymap("n", "<Space>LR", vim.cmd.LspRestart)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if lspdata.server_capabilities[client.name] then
      for k, v in pairs(lspdata.server_capabilities[client.name]) do
        client.server_capabilities[k] = v
      end
    end

    keymap("n", "K", function()
      vim.lsp.buf.hover({ border = consts.ICONS.BORDER })
    end, { buffer = true })
    keymap("n", "<Space>rn", vim.lsp.buf.rename, { buffer = true })
    keymap("n", "<Space>ca", vim.lsp.buf.code_action, { buffer = true })
    keymap("n", "<Space>F", conform.format, { buffer = true })
    keymap("n", "gd", telescope_builtin.lsp_definitions, { buffer = true })
    keymap("n", "gr", telescope_builtin.lsp_references, { buffer = true })
    keymap("n", "gD", telescope_builtin.lsp_type_definitions, { buffer = true })
    keymap("n", "gI", telescope_builtin.lsp_implementations, { buffer = true })
    keymap("n", "gi", telescope_builtin.lsp_incoming_calls, { buffer = true })
    keymap("n", "go", telescope_builtin.lsp_outgoing_calls, { buffer = true })
    keymap("n", "<C-LeftMouse>", function()
      inputs.norm("<LeftMouse>")
      vim.lsp.buf.definition()
    end, { buffer = true })
    keymap("n", "<C-RightMouse>", function()
      inputs.norm("<LeftMouse>")
      vim.lsp.buf.references()
    end, { buffer = true })
  end,
})
