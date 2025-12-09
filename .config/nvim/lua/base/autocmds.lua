local keymap = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local cmds = require("lib.cmds")
local consts = require("consts")
local state = require("state")
local strings = require("lib.base.string")
local sys = require("lib.system")
local winbufs = require("lib.winbuf")

-- Don't add the comment prefix on o/O
autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:append("r")
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- Line numeration toggle
autocmd({ "FocusLost", "WinLeave" }, { command = "setlocal norelativenumber" })
autocmd({ "VimEnter", "FocusGained", "WinEnter" }, {
  callback = function()
    if vim.o.number then
      vim.opt_local.relativenumber = true
    end
  end,
})
-- Dynamic autoscroll near window edges
autocmd({ "WinResized", "BufEnter" }, {
  callback = function()
    cmds.set_default_scrolloff()
  end,
})
autocmd("ModeChanged", {
  pattern = "[vV]:*", -- After visual selection with mouse
  callback = function()
    cmds.set_default_scrolloff()
  end,
})

-- Highlight yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})
-- Yank preserve position
autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" then
      pcall(function()
        cmds.norm("`m")
        vim.cmd.delmarks("m")
      end)
    end
  end,
})

-- Do not restore deleted marks
autocmd("VimLeavePre", { command = "wshada!" })

-- Easy Window closing
autocmd("CmdwinEnter", { callback = cmds.map_easy_closing })
autocmd("FileType", {
  pattern = { "help", "dap-float", "qf" },
  callback = cmds.map_easy_closing,
})
-- Close all auxiliary windows if all the main windows were closed
autocmd("WinEnter", {
  callback = function()
    if not winbufs.is_auxiliary_buffer() then
      return
    end
    for _, win in pairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if not winbufs.is_auxiliary_buffer(buf) then
        return
      end
    end
    vim.cmd("qa")
  end,
})

-- Open help | man in vertical split
autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "help" or vim.bo.filetype == "man" then
      vim.cmd.wincmd("L")
    end
  end,
})

-- Reset mapping for Cmd window
autocmd("CmdwinEnter", {
  callback = function()
    keymap("n", "<CR>", "<CR>", { buffer = true })
  end,
})

-- Disable numbers in terminal mode
autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
    vim.opt_local.signcolumn = "no"
    vim.bo.filetype = "terminal"
    vim.cmd.startinsert()
  end,
})
-- Consistent terminal mode after buffer switch
autocmd("WinEnter", {
  callback = function()
    if vim.bo.filetype == "terminal" and strings.contains(state.main_term.mode, "[tT]") then
      vim.cmd.startinsert()
    end
  end,
})
autocmd("WinLeave", {
  callback = function()
    if vim.bo.filetype == "terminal" then
      state.main_term.mode = vim.api.nvim_get_mode().mode
      vim.cmd.stopinsert()
    end
  end,
})

-- Auto language layout switch
local layout_enter_callback = function()
  sys.set_layout(state.notnorm_layout_idx)
end
local layout_exit_callback = function()
  state.notnorm_layout_idx = sys.get_layout()
  sys.set_layout(consts.LAYOUT.ENGLISH_IDX)
end
autocmd("InsertEnter", {
  callback = layout_enter_callback,
})
autocmd("CmdlineEnter", {
  callback = function()
    if vim.v.event.cmdtype == "/" then
      layout_enter_callback()
    end
  end,
})
autocmd("InsertLeave", {
  callback = layout_exit_callback,
})
autocmd("CmdlineLeave", {
  callback = function()
    if vim.v.event.cmdtype == "/" then
      layout_exit_callback()
    end
  end,
})

-- Auto detect Helm templates
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.yaml",
  callback = function(args)
    local content = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    if table.concat(content):find("{{.-}}") then
      vim.bo[args.buf].filetype = "gotmpl"
    end
  end,
})
