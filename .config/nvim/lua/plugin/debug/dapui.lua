local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local cmds = require("lib.cmds")
local consts = require("consts")
local dapui = require("dapui")
local utils = require("util.dapui")
local widgets = require("dap.ui.widgets")

dapui.setup({
  controls = { enabled = false },
  mappings = {
    add = "A",
    edit = "C",
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "O",
    remove = "D",
    repl = "r",
    toggle = "t",
  },
  element_mappings = {
    stacks = {
      open = { "<CR>", "<2-LeftMouse>" },
    },
  },
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
    {
      elements = {
        { id = "repl", size = 1 },
      },
      position = "bottom",
      size = 10,
    },
  },
  expand_lines = false,
  icons = {
    collapsed = ">",
    current_frame = ">",
    expanded = "v",
  },
  floating = { border = consts.ICONS.BORDER },
  render = {
    indent = 2,
    max_value_lines = 100,
  },
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

autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    keymap("i", "<C-K>", "<C-W>k", { buffer = true })
    keymap("i", "<C-P>", "<Up><End>", { buffer = true, remap = true })
    keymap("i", "<C-N>", "<Down><End>", { buffer = true, remap = true })
    keymap("n", "<CR>", function()
      local row = unpack(vim.api.nvim_win_get_cursor(0))
      local current_buffer = vim.api.nvim_win_get_buf(0)
      local count = vim.api.nvim_buf_line_count(current_buffer)
      if row == count then
        cmds.typekeys("<Insert><CR>")
      else
        utils.trigger_first_action()
      end
    end, { buffer = true, remap = true })
  end,
})
