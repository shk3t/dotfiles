local keymap = vim.keymap.set
local consts = require("consts")
local telescope_builtin = require("telescope.builtin")

vim.diagnostic.config({
  virtual_text = { severity = { min = "WARN" } },
  underline = { severity = { min = "WARN" } },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = consts.ICONS.DIAGNOSTIC.ERROR,
      [vim.diagnostic.severity.WARN] = consts.ICONS.DIAGNOSTIC.WARN,
      [vim.diagnostic.severity.INFO] = consts.ICONS.DIAGNOSTIC.INFO,
      [vim.diagnostic.severity.HINT] = consts.ICONS.DIAGNOSTIC.HINT,
    },
  },
  float = { border = consts.ICONS.BORDER },
})

-- Show diagnostics with max severity
local ns = vim.api.nvim_create_namespace("max_severity_diagnostic_sign")
local orig_signs_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    local diagnostics = vim.diagnostic.get(bufnr)

    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end

    local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
    pcall(orig_signs_handler.show, ns, bufnr, filtered_diagnostics, opts)
  end,
  hide = function(_, bufnr)
    orig_signs_handler.hide(ns, bufnr)
  end,
}

keymap("n", "<Space>dk", vim.diagnostic.open_float)
keymap("n", "<Space>td", telescope_builtin.diagnostics)
keymap("n", "[d", function()
  vim.diagnostic.jump({
    count = -1,
    float = true,
    severity = { min = "WARN" },
  })
end)
keymap("n", "]d", function()
  vim.diagnostic.jump({
    count = 1,
    float = true,
    severity = { min = "WARN" },
  })
end)
