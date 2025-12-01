local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local consts = require("consts")
local dap = require("dap")
local dapui = require("dapui")
local state = require("state")
local strings = require("lib.base.string")
local tables = require("lib.base.table")
local utils = require("plugin.util.debug")
local widgets = require("dap.ui.widgets")

state.dap.widgets.scopes = widgets.sidebar(widgets.scopes)

local function switch_thread_focus(step)
  if not utils.update_focused_thread() or step == 0 then
    return
  end
  local threads = tables.compact(dap.session().threads)
  local f_thread = state.dap.focus.thread

  local start
  for i, v in pairs(threads) do
    if v.id == f_thread.id then
      start = i + 1
      print("i:", i)
    end
  end
  local finish = start + #threads - 2
  if step < 0 then
    start, finish = finish, start
  end

  for i = start, finish, step do
    local thread = threads[(i - 1) % #threads + 1]
    if not strings.contains_any(thread.name, consts.DAP.RUNTIME_THREADS) then
      f_thread.id = thread.id
      f_thread.name = thread.name
      break
    end
  end

  widgets.centered_float(widgets.threads)
  vim.fn.search("\\V" .. f_thread.name)
  utils.trigger_first_action()
  vim.cmd.sleep("1m")
  vim.fn.search([[^\(.*\<\(]] .. table.concat(consts.DAP.RUNTIME_THREADS, [[\|]]) .. [[\)\>\)\@!.*$]])
  utils.trigger_first_action()
end

local dapui_config = {
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
}
dapui.setup(dapui_config)

keymap("n", "[t", function()
  switch_thread_focus(-1)
end)
keymap("n", "]t", function()
  switch_thread_focus(1)
end)
keymap("n", "<Space>ds", function()
  state.dap.widgets.scopes.toggle()
end)
keymap("n", "<Space>dt", function()
  widgets.centered_float(widgets.threads)
end)
keymap("n", "<Space>dg", dapui.toggle)
keymap({ "n", "v" }, "<Space>de", function(expr)
  widgets.hover(expr, { border = consts.ICONS.BORDER })
end)

autocmd("BufEnter", {
  pattern = "DAP Watches",
  callback = function()
    keymap("i", "<C-W>", "<C-O>db<BS>", { buffer = true })
    keymap("n", "u", vim.cmd.undo, { buffer = true })
  end,
})
