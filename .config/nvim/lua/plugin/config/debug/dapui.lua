local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local consts = require("consts")
local dapui = require("dapui")
local state = require("state")
local utils = require("plugin.util.dapui")
local widgets = require("dap.ui.widgets")

dapui.setup({
  controls = { enabled = false, element = "stacks" },
  icons = { collapsed = ">", current_frame = ">", expanded = "v" },
  mappings = {
    add = "A",
    edit = "C",
    expand = { "<CR>", "<2-LeftMouse>", "o" },
    open = "O",
    remove = "D",
    repl = "r",
    toggle = "t",
  },
  element_mappings = {
    stacks = { open = { "<CR>", "<2-LeftMouse>", "o" } },
    -- breakpoints = { open = { "<CR>", "<2-LeftMouse>", "o" } },
  },
  expand_lines = false,
  floating = { border = consts.ICONS.BORDER },
  layouts = {
    {
      elements = {
        { id = "stacks", size = 0.15 },
        { id = "scopes", size = 0.60 },
        { id = "watches", size = 0.25 },
      },
      position = "right",
      size = 90,
    },
    { elements = { { id = "repl", size = 1 } }, position = "bottom", size = 10 },
  },
  render = { indent = 2 },
})

keymap("n", "<Space>dg", dapui.toggle)
keymap({ "n", "x" }, "<Space>de", function(expr)
  widgets.hover(expr, { border = consts.ICONS.BORDER })
end)
keymap("n", "<Space>dt", function()
  widgets.centered_float(widgets.threads)
end)
keymap("n", "[T", function()
  utils.switch_thread_focus(-1)
end)
keymap("n", "]T", function()
  utils.switch_thread_focus(1)
end)

autocmd("BufEnter", {
  pattern = "DAP Watches",
  callback = function()
    keymap("i", "<C-W>", "<C-O>db<BS>", { buffer = true })
    keymap("n", "u", vim.cmd.undo, { buffer = true })
  end,
})
