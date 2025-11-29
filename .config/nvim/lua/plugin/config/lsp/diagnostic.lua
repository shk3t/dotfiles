local keymap = vim.keymap.set
local consts = require("consts")

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
keymap("n", "<Space>dk", vim.diagnostic.open_float)
keymap("n", "<Space>td", require("telescope.builtin").diagnostics)
-- require("neodim").setup({alpha = 0.6, update_in_insert = {enable = false}})

vim.diagnostic.config({
  virtual_text = { severity = { min = "WARN" } },
  underline = { severity = { min = "WARN" } },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = consts.DIAGNOSTIC_SIGNS.error,
      [vim.diagnostic.severity.WARN] = consts.DIAGNOSTIC_SIGNS.warn,
      [vim.diagnostic.severity.INFO] = consts.DIAGNOSTIC_SIGNS.info,
      [vim.diagnostic.severity.HINT] = consts.DIAGNOSTIC_SIGNS.hint,
    },
  },
  update_in_insert = false,
  float = { border = consts.VERTICAL_BORDERS },
})

-- Create a custom namespace. This will aggregate signs from all other
-- namespaces and only show the one with the highest severity on a
-- given line
local ns = vim.api.nvim_create_namespace("max_severity_diagnostic_sign")

-- Get a reference to the original signs handler
local orig_signs_handler = vim.diagnostic.handlers.signs

-- Override the built-in signs handler
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)

    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end

    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
    pcall(orig_signs_handler.show, ns, bufnr, filtered_diagnostics, opts)
  end,
  hide = function(_, bufnr)
    orig_signs_handler.hide(ns, bufnr)
  end,
}
