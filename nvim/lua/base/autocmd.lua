local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local lib = require("lib.main")

-- Line numeration toggle
autocmd({ "FocusLost", "WinLeave" }, { command = "set norelativenumber" })
autocmd({ "FocusGained", "WinEnter", "BufEnter" }, {
  callback = function()
    if vim.o.number then
      vim.opt.relativenumber = true
    end
  end,
})
autocmd({ "FocusGained", "WinEnter", "BufEnter", "WinResized" }, {
  callback = function()
    vim.o.scrolloff = math.floor(vim.api.nvim_win_get_height(0) / 5)
    vim.o.sidescrolloff = math.floor(vim.api.nvim_win_get_width(0) / 5)
  end,
})

-- Open help in vertical split
autocmd("BufEnter", {
  pattern = "*.txt",
  callback = function()
    if vim.o.buftype == "help" then
      vim.cmd.wincmd("L")
    end
  end,
})

-- Don't add the comment prefix when I hit o/O on a comment line.
autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:append("r")
    vim.opt_local.formatoptions:remove("c")
    vim.opt_local.formatoptions:remove("o")
  end,
})
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.formatoptions:remove("r")
  end,
})

-- Easy Window closing
local function map_easy_closing()
  keymap("n", "q", ":q<CR>", {
    buffer = true,
    silent = true,
  })
end
autocmd("CmdwinEnter", { callback = map_easy_closing })
autocmd("FileType", {
  pattern = { "help", "dap-float" },
  callback = map_easy_closing,
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
        lib.norm("`m")
        vim.cmd.delmarks("m")
      end)
    end
  end,
})

-- Do not restore deleted marks
autocmd("VimLeavePre", { command = "wshada!" })

-- Dap
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

-- Sql
autocmd("FileType", {
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    keymap({ "n" }, "<C-CR>", "mmvip<Plug>(DBUI_ExecuteQuery)", {
      buffer = true,
    })
    keymap({ "x" }, "<C-CR>", "mm<Plug>(DBUI_ExecuteQuery)", {
      buffer = true,
    })
    keymap({ "n", "x" }, "<C-S>", ":<C-U>write<CR><Plug>(DBUI_SaveQuery)", {
      buffer = true,
    })
  end,
})
autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    vim.opt_local.shiftwidth = 2
    keymap({ "n", "x" }, "D", "<Plug>(DBUI_DeleteLine)", { buffer = true })
  end,
})
autocmd("FileType", {
  pattern = "dbout",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.wrap = false
    vim.opt_local.cursorlineopt = "line"
    vim.diagnostic.disable()
  end,
})

-- Telescope
autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.wrap = true
    vim.opt_local.cursorline = true
  end,
})
-- Aerial
autocmd("FileType", {
  pattern = "aerial",
  callback = function()
    vim.opt_local.cursorlineopt = "line"
  end,
})
-- Harpoon
autocmd("FileType", {
  pattern = "harpoon",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
-- Git blame
autocmd("FileType", {
  pattern = "blame",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.wrap = false
    vim.opt_local.cursorlineopt = "line"
  end,
})
