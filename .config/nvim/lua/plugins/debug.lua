local dap = require("dap")
local dapui = require("dapui")
local dlib = require("lib.debug")
local lib = require("lib.main")
local widgets = require("dap.ui.widgets")
local local_configs = require("local.debug").local_configs
local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

local terminal_window_id = vim.fn.system([[xdotool getactivewindow]])
local tmux_window_id = vim.fn.system([[tmux display-message -p "#I"]])
dap.listeners.after.event_initialized["steal_focus"] = function()
  print("Debugger is active!")
end
dap.listeners.after.event_continued["steal_focus"] = function()
  tmux_window_id = vim.fn.system([[tmux display-message -p "#I"]])
end
dap.listeners.after.event_stopped["steal_focus"] = function()
  vim.fn.system("xdotool windowactivate " .. terminal_window_id)
  vim.fn.system("[[ $TMUX ]] && tmux select-window -t " .. tmux_window_id)
end

local dapui_config = {
  controls = { enabled = false, element = "stacks" },
  icons = { collapsed = ">", current_frame = ">", expanded = "v" },
  element_mappings = {
    stacks = { open = { "<CR>", "<2-LeftMouse>" }, expand = { "o", "O" } },
    watches = { remove = "D", edit = "C", repl = "S" },
  },
  expand_lines = false,
  floating = { border = "single" },
  layouts = {
    {
      elements = {
        { id = "watches", size = 0.1 },
        { id = "scopes", size = 0.75 },
        { id = "stacks", size = 0.15 },
      },
      position = "right",
      size = 65,
    },
    { elements = { { id = "repl", size = 1 } }, position = "bottom", size = 10 },
  },
  render = { indent = 2 },
}

local function breakpoint_jump(find_func)
  local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd.copen()
  dap.list_breakpoints()
  local qflist = vim.fn.getqflist()
  vim.cmd.cclose()
  vim.api.nvim_set_current_win(cur_win)
  qflist = lib.filter(function(v)
    return v.bufnr == cur_buf
  end, qflist)
  if lib.is_empty(qflist) then
    return
  end
  lib.save_jump()
  vim.api.nvim_win_set_cursor(0, { find_func(cur_row, qflist), cur_col })
end
local function bp_find_prev(cur_row, qflist)
  for i = #qflist, 1, -1 do
    if qflist[i].lnum - cur_row < 0 then
      return qflist[i].lnum
    end
  end
  return qflist[#qflist].lnum
end
local function bp_find_next(cur_row, qflist)
  for i = 1, #qflist do
    if qflist[i].lnum - cur_row > 0 then
      return qflist[i].lnum
    end
  end
  return qflist[1].lnum
end

keymap({ "i", "n", "x" }, "<F9>", dap.continue)
keymap({ "i", "n", "x" }, "<F8>", dap.step_over)
keymap({ "i", "n", "x" }, "<F7>", dap.step_into)
keymap({ "i", "n", "x" }, "<S-F8>", dap.step_out)
keymap({ "i", "n", "x" }, "<S-F9>", dap.goto_)
keymap("n", "<Space>b", dap.toggle_breakpoint)
keymap("n", "<Space>BC", function()
  dap.set_breakpoint(vim.fn.input(""))
end)
keymap("n", "<Space>BL", function()
  dap.set_breakpoint(nil, nil, vim.fn.input(""))
end)
keymap("n", "<Space>df", dap.focus_frame)
keymap("n", "[b", function()
  breakpoint_jump(bp_find_prev)
end)
keymap("n", "]b", function()
  breakpoint_jump(bp_find_next)
end)
keymap("n", "[s", dap.down)
keymap("n", "]s", dap.up)
keymap("n", "<Space>dc", dap.repl.open)
keymap("n", "<Space>dr", dap.run_last)
keymap("n", "<Space>ds", function()
  widgets.sidebar(widgets.scopes).open()
end)
keymap("n", "<Space>dg", dapui.toggle)
keymap({ "n", "x" }, "<Space>de", widgets.hover)

dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/alacritty",
  args = { "-e" },
}

dapui.setup(dapui_config)

dap.adapters.python = {
  type = "executable",
  command = dlib.python_path,
  args = { "-m", "debugpy.adapter" },
}
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = vim.env.HOME .. "/.local/share/nvim/mason/bin/OpenDebugAD7",
}
-- require("dap-vscode-js").setup({
--   -- https://github.com/mxsdev/nvim-dap-vscode-js/issues/58
--   -- https://www.reddit.com/r/neovim/comments/y7dvva/typescript_debugging_in_neovim_with_nvimdap/
--   debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
--   debugger_cmd = {"js-debug-adapter"},
--   adapters = {
--     "pwa-node",
--     "pwa-chrome",
--     "pwa-msedge",
--     "node-terminal",
--     "pwa-extensionHost",
--   },
-- })
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = vim.env.HOME .. "/.local/share/nvim/mason/bin/js-debug-adapter",
    args = { "${port}" },
  },
}
dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}

for _, language in pairs({ "python", "go" }) do
  dap.configurations[language] = {}
  for path, config in lib.sorted_pairs(local_configs[language]) do
    if lib.cwd_contains(path) then
      for _, config_entry in pairs(config) do
        table.insert(dap.configurations[language], config_entry)
      end
    end
  end
end

dap.configurations.c = {
  {
    name = "Default",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.getcwd() .. "/c.out"
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
    -- args = {function() return vim.fn.input("Args: ") end},
  },
}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

dap.configurations.javascript = {
  {
    name = "Default",
    type = "pwa-node",
    request = "launch",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
}

local typescript_configurations = vim.deepcopy(dap.configurations.javascript)
for _, config in pairs(typescript_configurations) do
  config.runtimeArgs = {
    "-r",
    "ts-node/register",
  }
end
dap.configurations.typescript = typescript_configurations

-- autocmd("BufWritePost", {
--   callback = function()
--     vim.cmd("silent lua require('dap').restart()")
--   end,
-- })
autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    keymap("i", "<C-K>", "<C-W>k", { buffer = true })
    keymap("i", "<C-L>", "<C-W>k", { buffer = true })
    keymap("i", "<C-Q>", "<C-W>k", { buffer = true })
    keymap("i", "<C-W>", "<C-O>db<BS>", { buffer = true })
    keymap("i", "<C-P>", "<Up><End>", { buffer = true, remap = true })
    keymap("i", "<C-N>", "<Down><End>", { buffer = true, remap = true })
    keymap("n", "<CR>", function()
      local row = unpack(vim.api.nvim_win_get_cursor(0))
      local current_buffer = vim.api.nvim_win_get_buf(0)
      local count = vim.api.nvim_buf_line_count(current_buffer)
      if row == count then
        vim.api.nvim_input("<Insert><CR>")
      else
        require("dap.ui").trigger_actions({ mode = "first" })
      end
    end, { buffer = true, remap = true })
  end,
})
autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    keymap("i", "<C-K>", "<C-W>k", { buffer = true })
    keymap("i", "<C-L>", "<C-W>k", { buffer = true })
    keymap("i", "<C-Q>", "<C-W>k", { buffer = true })
    keymap("i", "<C-W>", "<C-O>db<BS>", { buffer = true })
    keymap("i", "<C-P>", "<Up><End>", { buffer = true, remap = true })
    keymap("i", "<C-N>", "<Down><End>", { buffer = true, remap = true })
    keymap("n", "<CR>", function()
      local row = unpack(vim.api.nvim_win_get_cursor(0))
      local current_buffer = vim.api.nvim_win_get_buf(0)
      local count = vim.api.nvim_buf_line_count(current_buffer)
      if row == count then
        vim.api.nvim_input("<Insert><CR>")
      else
        require("dap.ui").trigger_actions({ mode = "first" })
      end
    end, { buffer = true, remap = true })
  end,
})
autocmd("BufEnter", {
  pattern = "DAP Watches",
  callback = function()
    keymap("i", "<C-W>", "<C-O>db<BS>", { buffer = true })
  end,
})
